import Foundation

public typealias MessageReceivedClosure = (BskyMessage) -> Void
public typealias ErrorReceivedClosure = (any Error) -> Void

public actor BskyFirehoseClient: Sendable {
	private var onMessageReceived: MessageReceivedClosure?
	private var onErrorProcessingMessage: ErrorReceivedClosure?
	public let settings: BskyFirehoseSettings
	
	private lazy var mapper = BskyFirehoseSettingsMapper()
	private var bskyMessageManager: any BskyMessageManager = AllMessagesManager()
	
	private var websocketTask: URLSessionWebSocketTask?
	private var status: BskyFirehoseClient.Status = .closed
	
	public var isConnected: Bool {
		guard let websocketTask else { return false }
		return status == .connected
	}
	
	init(settings: BskyFirehoseSettings) {
		self.settings = settings
	}
	
	private func connect() throws(BskyFirehoseError) {
		do {
			let firehoseURL = try mapper.mapToURL(from: settings)
			websocketTask = URLSession.shared.webSocketTask(with: firehoseURL)
		} catch is FirehoseMapperError {
			throw .invalidFirehoseURL
		}
	}
	
	public func start() throws {
		guard websocketTask?.state != .running else {
			return
		}
		
		try connect()
		websocketTask?.resume()
		status = .connected
		
		Task {
			try await processIncomingMessage()
		}
	}
	
	public func stop() {
		websocketTask?.cancel()
		status = .closed
	}
	
	private func processIncomingMessage() async throws {
		if let message = try await websocketTask?.receive() {
			do {
				var incomingMessage: BskyMessage?
				
				switch message {
					case .data(let data):
						incomingMessage = try bskyMessageManager.processMessage(content: data)
					case .string(let content):
						incomingMessage = try bskyMessageManager.processMessage(string: content)
					@unknown default:
						fatalError()
				}
				
				if let onMessageReceived, let incomingMessage {
					onMessageReceived(incomingMessage)
				}
			} catch let error {
				onErrorProcessingMessage?(error)
			}
		}
		
		await Task.yield()
				
		try await processIncomingMessage()
	}
	
	public func onMessageReceived(_ perform: @escaping MessageReceivedClosure) {
		onMessageReceived = perform
	}
	
	public func onErrorReceived(_ perform: @escaping ErrorReceivedClosure) {
		onErrorProcessingMessage = perform
	}
	
	public func manageMessages(using messageManager: any BskyMessageManager) {
		bskyMessageManager = messageManager
	}
}

extension BskyFirehoseClient {
	enum Status {
		case connected
		case closed
	}
}
