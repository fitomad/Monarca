//
//  DefaultFirehoseClientsBuilder.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public final class DefaultFirehoseClientBuilder: BskyFirehoseClientBuilder {
	private var settings: BskyFirehoseSettings
	private var onMessageReceived: MessageReceivedClosure?
	private var onErrorProcessingMessage: ErrorReceivedClosure?
	
	public init() {
		settings = BskyFirehoseSettings()
	}
    
	public func withHost(_ server: FireshoseHost) async -> Self {
		settings.set(host: server)
        return self
    }
    
	@available(*, deprecated, message: "Use the `withCollections(_: [Collection])` method instead.")
	public func withCollections(_ collection: [String]) async -> Self {
		settings.set(collections: collection)
        return self
    }
	
	public func withCollections(_ collection: [Collection]) async -> Self {
		let collectionsRawValues = collection.map { $0.rawValue }
		settings.set(collections: collectionsRawValues)
		
		return self
	}
    
	public func withDecentralizedIdentifiers(_ identifiers: [String]) async -> Self {
		settings.set(decentralizedIdentifiers: identifiers)
        return self
    }
    
	public func withMaximumMessageSize(_ size: MessageSize) async -> Self {
		settings.set(maximumMessageSize: size)
        return self
    }
    
	public func withPlayback(_ playback: Playback) async -> Self {
		settings.set(playback: playback)
        return self
    }
    
	public func withCompressionEnabled(_ value: Bool) async -> Self {
		settings.set(isCompressionEnabled: value)
        return self
    }
    
	public func withHelloExecution(_ value: Bool) async -> Self {
		settings.set(isHelloRequired: value)
        return self
    }
	
	public func withMessageManager(_ messageManager: any BskyMessageManager) async -> Self {
		settings.set(messageManager: messageManager)
		return self
	}
	
	public func onMessageReceived(_ closure: @escaping MessageReceivedClosure) -> Self {
		onMessageReceived = closure
		return self
	}
	
	public func onErrorProcessingMessage(_ closure: @escaping ErrorReceivedClosure) -> Self {
		onErrorProcessingMessage = closure
		return self
	}
    
    public func reset() async {
		await settings.reset()
    }
    
	
	public func build() async throws(BskyFirehoseError) -> BskyFirehoseClient {
		guard let _ = settings.host else {
			throw BskyFirehoseError.invalidConnectionParameters
		}
		
		if settings.messageManager == nil {
			await settings.set(messageManager: AllMessagesManager())
		}
		
		return BskyFirehoseClient(settings: settings,
								  onMessageReceived: onMessageReceived,
								  onErrorProcessingMessage: onErrorProcessingMessage)
    }
}
