//
//  BskyFirehoseClientBuilder.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//


public protocol BskyFirehoseClientBuilder {
    func withHost(_ server: FireshoseHost) -> Self
    func withCollections(_ collection: [String]) -> Self
    func withDecentralizedIdentifiers(_ identifiers: [String]) -> Self
    func withMaximumMessageSize(_ size: MessageSize) -> Self
    func withPlayback(_ playback: Playback) -> Self
    func withCompressionEnabled(_ value: Bool) -> Self
    func withHelloExecution(_ value: Bool) -> Self
	
	func withMessageManager(_ messageManager: BskyMessageManager) -> Self
    
    func reset()
    func build() async throws -> BskyFirehoseClient
}
