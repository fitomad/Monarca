//
//  DefaultFirehoseClientsBuilder.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public final class DefaultFirehoseClientBuilder: BskyFirehoseClientBuilder {
	private var settings: BskyFirehoseSettings
	
	public init() {
		settings = BskyFirehoseSettings()
	}
    
	public func withHost(_ server: FireshoseHost) -> Self {
		settings.set(host: server)
        return self
    }
    
	@available(*, deprecated, message: "Use the `withCollections(_: [Collection])` method instead.")
	public func withCollections(_ collection: [String]) -> Self {
		settings.set(collections: collection)
        return self
    }
	
	public func withCollections(_ collection: [Collection]) -> Self {
		let collectionsRawValues = collection.map { $0.rawValue }
		settings.set(collections: collectionsRawValues)
		
		return self
	}
    
	public func withDecentralizedIdentifiers(_ identifiers: [String]) -> Self {
		settings.set(decentralizedIdentifiers: identifiers)
        return self
    }
    
	public func withMaximumMessageSize(_ size: MessageSize) -> Self {
		settings.set(maximumMessageSize: size)
        return self
    }
    
	public func withPlayback(_ playback: Playback) -> Self {
		settings.set(playback: playback)
        return self
    }
    
	public func withCompressionEnabled(_ value: Bool) -> Self {
		settings.set(isCompressionEnabled: value)
        return self
    }
    
	public func withHelloExecution(_ value: Bool) -> Self {
		settings.set(isHelloRequired: value)
        return self
    }
	
	public func withMessageManager(_ messageManager: any BskyMessageManager) -> Self {
		settings.set(messageManager: messageManager)
		return self
	}
    
    public func reset() {
		settings.reset()
    }
    
	
	public func build() throws(BskyFirehoseError) -> BskyFirehoseClient {
		guard let _ = settings.host else {
			throw BskyFirehoseError.invalidConnectionParameters
		}
		
		if settings.messageManager == nil {
			settings.set(messageManager: AllMessagesManager())
		}
		
		return BskyFirehoseClient(settings: settings)
    }
}
