import Foundation

public typealias MessageReceivedClosure = (BskyMessage) -> Void
public typealias ErrorReceivedClosure = (any Error) -> Void

public final class BskyFirehoseClient {
	private var onMessageReceived: MessageReceivedClosure?
	private var onErrorProcessingMessage: ErrorReceivedClosure?
	public let settings: BskyFirehoseSettings
	
	private lazy var mapper = BskyFirehoseSettingsMapper()
	private var bskyMessageManager: any BskyMessageManager = AllMessagesManager()
	
	private var websocketTask: URLSessionWebSocketTask?
	private var status: BskyFirehoseClient.Status = .closed
	
	public var isConnected: Bool {
		status == .connected
	}
	
	init(settings:  BskyFirehoseSettings) {
		self.settings = settings
	}
	
	private func connect() throws(BskyFirehoseError) {
		do {
			let firehoseURL = try mapper.mapToURL(from: settings)
			websocketTask = URLSession.shared.webSocketTask(with: firehoseURL)
			status = .connected
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
		
		Task(priority: .background) {
			try await processIncomingMessage()
		}
	}
	
	public func stop() {
		guard let websocketTask else { return }
		websocketTask.cancel(with: .normalClosure, reason: nil)
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
		self.onMessageReceived = perform
	}
	
	public func onErrorProcessingMessage(_ perform: @escaping ErrorReceivedClosure) {
		self.onErrorProcessingMessage = perform
	}
}

extension BskyFirehoseClient {
	enum Status {
		case connected
		case closed
	}
}
