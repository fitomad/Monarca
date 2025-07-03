//
//  BskyFirehoseClientBuilder.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//


public protocol BskyFirehoseClientBuilder {
    func withHost(_ server: FireshoseHost) async -> Self
	func withCollections(_ collection: [String]) async -> Self
	func withCollections(_ collection: [Collection]) async -> Self
	func withDecentralizedIdentifiers(_ identifiers: [String]) async -> Self
	func withMaximumMessageSize(_ size: MessageSize) async -> Self
	func withPlayback(_ playback: Playback) async -> Self
	func withCompressionEnabled(_ value: Bool) async -> Self
	func withHelloExecution(_ value: Bool) async -> Self
	func withMessageManager(_ messageManager: BskyMessageManager) async -> Self
    
    func reset() async 
	func build() async throws -> BskyFirehoseClient
}
