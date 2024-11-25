//
//  DefaultFirehoseClientsBuilder.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public struct DefaultFirehoseClientBuilder: BskyFirehoseClientBuilder {
	private let settings: BskyFirehoseSettings
	
	public init() {
		settings = BskyFirehoseSettings()
	}
    
	public func withHost(_ server: FireshoseHost) async -> Self {
		await settings.set(host: server)
        return self
    }
    
    public func withCollections(_ collection: [String]) async -> Self {
		await settings.set(collections: collection)
        return self
    }
    
    public func withDecentralizedIdentifiers(_ identifiers: [String]) async -> Self {
		await settings.set(decentralizedIdentifiers: identifiers)
        return self
    }
    
    public func withMaximumMessageSize(_ size: MessageSize) async -> Self {
		await settings.set(maximumMessageSize: size)
        return self
    }
    
    public func withPlayback(_ playback: Playback) async -> Self {
		await settings.set(playback: playback)
        return self
    }
    
    public func withCompressionEnabled(_ value: Bool) async -> Self {
		await settings.set(isCompressionEnabled: value)
        return self
    }
    
    public func withHelloExecution(_ value: Bool) async -> Self {
		await settings.set(isHelloRequired: value)
        return self
    }
	
	  public func withMessageManager(_ messageManager: any BskyMessageManager) async -> Self {
		    await settings.set(messageManager: messageManager)
		    return self
	  }
    
    public mutating func reset() async {
		await settings.reset()
    }
    
	 public func build() async throws(BskyFirehoseError) -> sending BskyFirehoseClient {
		guard let _ = await settings.host else {
			throw BskyFirehoseError.invalidConnectionParameters
		}
		
		if await settings.messageManager == nil {
			await settings.set(messageManager: AllMessagesManager())
		}
		
		let client = BskyFirehoseClient(settings: settings)
		
		return client
    }
}
