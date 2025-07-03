//
//  BskyFirehoseClient.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation
import NIO
import NIOFoundationCompat
import WebSocketKit

public typealias MessageReceivedClosure = @Sendable (BskyMessage) -> Void
public typealias ErrorReceivedClosure = (BskyFirehoseError) -> Void

public actor BskyFirehoseClient: Sendable {
	private var onMessageReceived: MessageReceivedClosure?
	private var onErrorProcessingMessage: ErrorReceivedClosure?
	public let settings: BskyFirehoseSettings
	
	private lazy var mapper = BskyFirehoseSettingsMapper()
	
	private let eventLoopGroup: MultiThreadedEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
	
	private var status: BskyFirehoseClient.Status = .closed
	
	public var isConnected: Bool {
		status == .connected
	}
	
	init(settings:  BskyFirehoseSettings) {
		self.settings = settings
	}

	public func start() async throws {
		guard let bskyMessageManager = await settings.messageManager else {
			throw BskyFirehoseError.messageManagerNotAvailable
		}
		
		let mapper = BskyFirehoseSettingsMapper()
		
		guard let bskyURL = try? await mapper.mapToURL(from: settings) else {
			throw BskyFirehoseError.invalidConnectionParameters
		}
		
		WebSocket.connect(to: bskyURL, on: eventLoopGroup) { ws in
				var incomingMessage: BskyMessage?
				
				ws.onText { ws, content in
					if let incomingMessage = try? await bskyMessageManager.processMessage(string: content) {
						await self.onMessageReceived?(incomingMessage)
					}
				}
				
				ws.onBinary { ws, byteBuffer in
					let data = Data(buffer: byteBuffer)
					if let incomingMessage = try? await bskyMessageManager.processMessage(content: data) {
						await self.onMessageReceived?(incomingMessage)
					}
				}
		}

		
		status = .connected
	}
	
	public func stop() {
		guard isConnected else {
			return
		}
		
		status = .closed
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
