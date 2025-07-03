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
public typealias ErrorReceivedClosure = @Sendable (BskyFirehoseError) -> Void

public actor BskyFirehoseClient {
	private var onMessageReceived: MessageReceivedClosure?
	private var onErrorProcessingMessage: ErrorReceivedClosure?
	public let settings: BskyFirehoseSettings
	
	private let eventLoopGroup: MultiThreadedEventLoopGroup
	
	private var mapper: BskyFirehoseSettingsMapper {
		BskyFirehoseSettingsMapper()
	}
	
	init(settings:  BskyFirehoseSettings){
		self.settings = settings
		eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: settings.dedicatedThreads)
	}

	public func start() async throws {
		guard let bskyMessageManager = settings.messageManager else {
			throw BskyFirehoseError.messageManagerNotAvailable
		}
		
		let mapper = BskyFirehoseSettingsMapper()
		
		guard let bskyURL = try? await mapper.mapToURL(from: settings) else {
			throw BskyFirehoseError.invalidConnectionParameters
		}
		
		WebSocket.connect(to: bskyURL, on: eventLoopGroup) { ws in
			ws.onText { ws, content in
				do {
					let incomingMessage = try await bskyMessageManager.processMessage(string: content)
					await self.onMessageReceived?(incomingMessage)
				} catch {
					await self.onErrorProcessingMessage?(.invalidMessage(content: .string(content)))
				}
			}
			
			ws.onBinary { ws, byteBuffer in
				let bytes = Data(buffer: byteBuffer)
				
				do {
					let incomingMessage = try await bskyMessageManager.processMessage(content: bytes)
					await self.onMessageReceived?(incomingMessage)
				} catch {
					await self.onErrorProcessingMessage?(.invalidMessage(content: .data(bytes)))
				}
			}
		}
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
