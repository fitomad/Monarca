//
//  BskyFirehoseClient.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation
import NIOCore
import NIOHTTP1
import NIOPosix
import NIOWebSocket
import NIOFoundationCompat

public typealias MessageReceivedClosure = (BskyMessage) -> Void
public typealias ErrorReceivedClosure = (BskyFirehoseError) -> Void

public actor BskyFirehoseClient: Sendable {
	private var onMessageReceived: MessageReceivedClosure?
	private var onErrorProcessingMessage: ErrorReceivedClosure?
	public let settings: BskyFirehoseSettings
	
	private lazy var mapper = BskyFirehoseSettingsMapper()
	
	private let eventLoopGroup: MultiThreadedEventLoopGroup = .singleton
	private var channel: Channel?
	
	private var status: BskyFirehoseClient.Status = .closed
	
	public var isConnected: Bool {
		status == .connected
	}
	
	init(settings:  BskyFirehoseSettings) {
		self.settings = settings
	}

	public func start() async throws {
		let mapper = BskyFirehoseSettingsMapper()
		
		guard let bskyURL = try? await mapper.mapToURL(from: settings),
			  let parsedURL = mapper.mapToWebSocketBootstrap(from: bskyURL)
		else
		{
			throw BskyFirehoseError.invalidConnectionParameters
		}
		
		let upgradeResult: EventLoopFuture<UpgradeResult> = try await ClientBootstrap(group: self.eventLoopGroup)
			.connect(host: parsedURL.host, port: parsedURL.port) { channel in
			channel.eventLoop.makeCompletedFuture {
				let upgrader = NIOTypedWebSocketClientUpgrader<UpgradeResult>(
					upgradePipelineHandler: { (channel, _) in
						channel.eventLoop.makeCompletedFuture {
							let asyncChannel = try NIOAsyncChannel<WebSocketFrame, WebSocketFrame>(
								wrappingChannelSynchronously: channel
							)
							return UpgradeResult.websocket(asyncChannel)
						}
					}
				)
				
				var headers = HTTPHeaders()
				headers.add(name: "Content-Type", value: "text/plain; charset=utf-8")
				headers.add(name: "Content-Length", value: "0")
				
				let requestHead = HTTPRequestHead(
					version: .http1_1,
					method: .GET,
					uri: parsedURL.path.isEmpty ? "/" : parsedURL.path,
					headers: headers
				)
				
				let clientUpgradeConfiguration = NIOTypedHTTPClientUpgradeConfiguration(
					upgradeRequestHead: requestHead,
					upgraders: [upgrader],
					notUpgradingCompletionHandler: { channel in
						channel.eventLoop.makeCompletedFuture {
							UpgradeResult.notUpgraded
						}
					}
				)
				
				let negotiationResultFuture = try channel.pipeline.syncOperations
					.configureUpgradableHTTPClientPipeline(
						configuration: .init(upgradeConfiguration: clientUpgradeConfiguration)
					)
				
				return negotiationResultFuture
			}
		}
		
		try await self.handleUpgradeResult(upgradeResult)
		
		status = .connected
	}
	
	public func stop() {
		guard isConnected else {
			return
		}
		
		status = .closed
	}
	
	private func handleUpgradeResult(_ upgradeResult: EventLoopFuture<UpgradeResult>) async throws {
		guard let result = try? await upgradeResult.get() else {
			throw BskyFirehoseError.invalidFirehoseURL
		}
		
		switch result {
			case .websocket(let websocketChannel):
				print("Handling websocket connection")
				try await self.handleWebsocketChannel(websocketChannel)
				print("Done handling websocket connection")
			case .notUpgraded:
				// The upgrade to websocket did not succeed. We are just exiting in this case.
				print("Upgrade declined")
		}
	}
	
	private func handleWebsocketChannel(_ channel: NIOAsyncChannel<WebSocketFrame, WebSocketFrame>) async throws {
		guard let bskyMessageManager = await settings.messageManager else {
			throw BskyFirehoseError.messageManagerNotAvailable
		}

		let pingFrame = WebSocketFrame(fin: true, opcode: .ping, data: ByteBuffer(string: "Hello!"))
		try await channel.executeThenClose { inbound, outbound in
			try await outbound.write(pingFrame)

			for try await frame in inbound {
				var incomingMessage: BskyMessage?
				
				switch frame.opcode {
					case .pong:
						print("Received pong: \(String(buffer: frame.data))")

					case .text:
						let content = String(buffer: frame.data)
						incomingMessage = try await bskyMessageManager.processMessage(string: content)

					case .connectionClose:
						// Handle a received close frame. We're just going to close by returning from this method.
						print("Received Close instruction from server")
						return
					case .binary, .continuation, .ping:
						let data = Data(buffer: frame.data)
						incomingMessage = try await bskyMessageManager.processMessage(content: data)
					default:
						throw BskyMessageManagerError.nonValidMessage
				}
				
				if let onMessageReceived, let incomingMessage {
					onMessageReceived(incomingMessage)
				}
			}
		}
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
	
	enum UpgradeResult {
		case websocket(NIOAsyncChannel<WebSocketFrame, WebSocketFrame>)
		case notUpgraded
	}
}
