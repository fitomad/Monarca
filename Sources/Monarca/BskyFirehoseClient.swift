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

public final class BskyFirehoseClient: Sendable {
	private let onMessageReceived: MessageReceivedClosure?
	private let onErrorProcessingMessage: ErrorReceivedClosure?
	public let settings: BskyFirehoseSettings
	
	private let eventLoopGroup: MultiThreadedEventLoopGroup
	
	private var mapper: BskyFirehoseSettingsMapper {
		BskyFirehoseSettingsMapper()
	}
	
	init(settings:  BskyFirehoseSettings,
		 onMessageReceived: MessageReceivedClosure? = nil,
		 onErrorProcessingMessage: ErrorReceivedClosure? = nil)
	{
		self.settings = settings
		eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: settings.dedicatedThreads)
		
		self.onMessageReceived = onMessageReceived
		self.onErrorProcessingMessage = onErrorProcessingMessage
	}

	public func start() async throws {
		guard let bskyMessageManager = settings.messageManager else {
			throw BskyFirehoseError.messageManagerNotAvailable
		}
		
		let mapper = BskyFirehoseSettingsMapper()
		
		guard let bskyURL = try? await mapper.mapToURL(from: settings) else {
			throw BskyFirehoseError.invalidConnectionParameters
		}
		
		WebSocket.connect(to: bskyURL, on: eventLoopGroup) { [weak self] ws in
			ws.onText { ws, content in
				do {
					let incomingMessage = try await bskyMessageManager.processMessage(string: content)
					self?.onMessageReceived?(incomingMessage)
				} catch {
					self?.onErrorProcessingMessage?(.invalidMessage(content: .string(content)))
				}
			}
			
			ws.onBinary { ws, byteBuffer in
				let bytes = Data(buffer: byteBuffer)
				
				do {
					let incomingMessage = try await bskyMessageManager.processMessage(content: bytes)
					self?.onMessageReceived?(incomingMessage)
				} catch {
					self?.onErrorProcessingMessage?(.invalidMessage(content: .data(bytes)))
				}
			}
		}
	}
}

extension BskyFirehoseClient {
	enum Status {
		case connected
		case closed
	}
}
