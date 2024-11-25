import Foundation

public typealias MessageReceivedClosure = (BskyMessage) -> Void
public typealias ErrorReceivedClosure = (BskyFirehoseError) -> Void

public actor BskyFirehoseClient: Sendable {
	private var onMessageReceived: MessageReceivedClosure?
	private var onErrorProcessingMessage: ErrorReceivedClosure?
	public let settings: BskyFirehoseSettings
	
	private lazy var mapper = BskyFirehoseSettingsMapper()
	
	private var websocketTask: URLSessionWebSocketTask?
	private var status: BskyFirehoseClient.Status = .closed
	
	public var isConnected: Bool {
		status == .connected
	}
	
	init(settings:  BskyFirehoseSettings) {
		self.settings = settings
	}
	
	public func start() async throws {
		guard websocketTask?.state != .running else {
			return
		}
		
		try await connect()
		self.websocketTask?.resume()
	}
	
	public func stop() {
		guard let websocketTask else { return }
		websocketTask.cancel(with: .normalClosure, reason: nil)
		status = .closed
	}
	
	public func receive() {
		Task {
			try await processIncomingMessage()
		}
	}
	
	private func connect() async throws(BskyFirehoseError) {
		do {
			let firehoseURL = try await mapper.mapToURL(from: settings)
			websocketTask = URLSession.shared.webSocketTask(with: firehoseURL)
			status = .connected
		} catch is FirehoseMapperError {
			throw .invalidFirehoseURL
		}
	}
	
	private func processIncomingMessage() async throws {
		guard let bskyMessageManager = await settings.messageManager else {
			throw BskyFirehoseError.messageManagerNotAvailable
		}
		
		if let message = try await websocketTask?.receive() {
			do {
				var incomingMessage: BskyMessage?
				
				switch message {
					case .data(let data):
						incomingMessage = try await bskyMessageManager.processMessage(content: data)
					case .string(let content):
						incomingMessage = try await bskyMessageManager.processMessage(string: content)
					@unknown default:
						fatalError()
				}
				
				if let onMessageReceived, let incomingMessage {
					onMessageReceived(incomingMessage)
				}
			} catch {
				onErrorProcessingMessage?(.invalidMessage(content: message))
			}
		}
		
		await Task.yield()
				
		try await processIncomingMessage()
	}
	
	public func onMessageReceived(_ perform: @escaping @Sendable MessageReceivedClosure) {
		self.onMessageReceived = perform
	}
	
	public func onErrorProcessingMessage(_ perform: @escaping @Sendable ErrorReceivedClosure) {
		self.onErrorProcessingMessage = perform
	}
}

extension BskyFirehoseClient {
	enum Status {
		case connected
		case closed
	}
}
