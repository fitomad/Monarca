//
//  DefaultFirehoseClientsBuilder.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public final class DefaultFirehoseClientBuilder: BskyFirehoseClientBuilder {
	private var settings = BskyFirehoseSettings()
	private var messageManager: any BskyMessageManager
	
	init() {
		settings = BskyFirehoseSettings()
		messageManager = AllMessagesManager()
	}
    
	public func withHost(_ server: FireshoseHost) -> Self {
		settings.host = server
        return self
    }
    
    public func withCollections(_ collection: [String]) -> Self {
        settings.collections = collection
        return self
    }
    
    public func withDecentralizedIdentifiers(_ identifiers: [String]) -> Self {
        settings.decentralizedIdentifiers = identifiers
        return self
    }
    
    public func withMaximumMessageSize(_ size: MessageSize) -> Self {
        settings.maximumMessageSize = size
        return self
    }
    
    public func withPlayback(_ playback: Playback) -> Self {
        settings.playback = playback
        return self
    }
    
    public func withCompressionEnabled(_ value: Bool) -> Self {
        settings.isCompressionEnabled = value
        return self
    }
    
    public func withHelloExecution(_ value: Bool) -> Self {
        settings.isHelloRequired = value
        return self
    }
	
	public func withMessageManager(_ messageManager: any BskyMessageManager) -> Self {
		self.messageManager = messageManager
		return self
	}
    
    public func reset() {
        settings = BskyFirehoseSettings()
		messageManager = AllMessagesManager()
    }
    
	public func build() async throws(BskyFirehoseError) -> BskyFirehoseClient {
		guard let _ = settings.host else {
			throw BskyFirehoseError.invalidConnectionParameters
		}
		
		let client = BskyFirehoseClient(settings: settings)
		
		Task { @MainActor in
			await client.manageMessages(using: messageManager)
		}
		
		
		return client
    }
}
