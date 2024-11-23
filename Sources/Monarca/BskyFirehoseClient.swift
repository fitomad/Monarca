import Foundation

public typealias MessageReceived = (BskyMessage) -> Void
public typealias ErrorReceived = (any Error) -> Void

public final class BskyFirehoseClient: Sendable {
	public var onMessageReceived: MessageReceived?
	public var onErrorProcessingMessage: ErrorReceived?
	public let settings: BskyFirehoseSettings
	
	private lazy var mapper = BskyFirehoseSettingsMapper()
	private var bskyMessageManager: any BskyMessageManager = AllMessagesManager()
	
	private var websocketTask: URLSessionWebSocketTask?
	
	public var isConnected: Bool {
		guard let websocketTask else { return false }
		return websocketTask.state == .running
	}
	
	init(settings: BskyFirehoseSettings, messageManager: (any BskyMessageManager)? = nil) {
		self.settings = settings
		
		if let messageManager {
			self.bskyMessageManager = messageManager
		}
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
		
		Task {
			try await processIncomingMessage()
		}
	}
	
	public func stop() {
		websocketTask?.cancel()
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
}
