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
	public let settings: BskyFirehoseSettings
	
	private var onMessageReceived: MessageReceivedClosure?
	private var onErrorProcessingMessage: ErrorReceivedClosure?
	
	private let eventLoopGroup: MultiThreadedEventLoopGroup
	private var webSocket: WebSocket?
	
	private var status: BskyFirehoseClient.Status = .closed
	
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
		
		_ = WebSocket.connect(to: bskyURL, on: eventLoopGroup) { ws in
			Task { [weak self] in
				await self?.setWebSocket(ws)
				await self?.setStatus(.connected)
			}
			
			ws.onText { [weak self] ws, content in
				do {
					let incomingMessage = try await bskyMessageManager.processMessage(string: content)
					await self?.onMessageReceived?(incomingMessage)
				} catch {
					await self?.onErrorProcessingMessage?(.invalidMessage(content: .string(content)))
				}
			}
			
			ws.onBinary { [weak self] ws, byteBuffer in
				let bytes = Data(buffer: byteBuffer)
				
				do {
					let incomingMessage = try await bskyMessageManager.processMessage(content: bytes)
					await self?.onMessageReceived?(incomingMessage)
				} catch {
					await self?.onErrorProcessingMessage?(.invalidMessage(content: .data(bytes)))
				}
			}
		}
	}
	
	public func stop() async throws {
		guard status == .connected else { return }
		
		try await webSocket?.close()
		webSocket = nil
		status = .closed
	}
	
	public func shutdown() async throws {
		try await stop()
		try await eventLoopGroup.shutdownGracefully()
	}

	public func onMessageReceived(_ perform: @escaping MessageReceivedClosure) {
		self.onMessageReceived = perform
	}
	
	public func onErrorProcessingMessage(_ perform: @escaping ErrorReceivedClosure) {
		self.onErrorProcessingMessage = perform
	}
	
	private func setWebSocket(_ ws: WebSocket) {
		webSocket = ws
	}
	
	private func setStatus(_ newStatus: BskyFirehoseClient.Status) {
		status = newStatus
	}
}

extension BskyFirehoseClient {
	enum Status {
		case connected
		case closed
	}
}
