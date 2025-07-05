//
//  DefaultFirehoseClientsBuilder.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public final class DefaultFirehoseClientBuilder: BskyFirehoseClientBuilder {
	private var settings: BskyFirehoseSettings
	private var filterMessageHandler: [any BskyMessageHandler]
	
	public init() {
		settings = BskyFirehoseSettings()
		filterMessageHandler = []
	}
	
	public func connect(to host: FireshoseHost) -> Self {
		settings.set(host: host)
		return self
	}
	
	public func forCollections(_ collection: [BskyCollection]) -> Self {
		let collectionsRawValues = collection.map { $0.description }
		settings.set(collections: collectionsRawValues)
		
		return self
	}
    
	public func withDecentralizedIdentifiers(_ identifiers: [String]) -> Self {
		settings.set(decentralizedIdentifiers: identifiers)
        return self
    }
	
	public func maximumMessageSizeAllowed(_ size: MessageSize) -> Self {
		settings.set(maximumMessageSize: size)
		return self
	}
    
	public func messagesPlayback(since moment: Playback) -> Self {
		settings.set(playback: moment)
		return self
	}
    
	public func compressionEnabled(_ value: Bool) -> Self {
		settings.set(isCompressionEnabled: value)
		return self
	}
    
	public func withHelloExecution(_ value: Bool) -> Self {
		settings.set(isHelloRequired: value)
        return self
    }
	
	public func useCustomMessageManager(_ messageManager: any BskyMessageManager) -> Self {
		settings.set(messageManager: messageManager)
		return self
	}
	
	public func dedicatedThreads(count: Int) -> Self {
		settings.set(dedicatedThreads: count)
		return self
	}
	
	public func applyContentFilter(by terms: [String]) -> Self {
		filterMessageHandler.append(ContentFilteredCommitMessageHandler(by: terms))
		return self
	}
	
	public func applyHashtagFilter(by hashtags: [String]) -> Self {
		filterMessageHandler.append(HashtagFilteredCommitMessageHandler(by: hashtags))
		return self
	}
    
    public func reset() {
		settings.reset()
		filterMessageHandler.removeAll()
    }
    
	public func build() throws(BskyFirehoseError) -> BskyFirehoseClient {
		guard let _ = settings.host else {
			throw BskyFirehoseError.invalidConnectionParameters
		}
		
		if settings.messageManager == nil {
			settings.set(messageManager: AllMessagesManager())
		}
		
		if filterMessageHandler.isEmpty == false {
			if let collections = settings.collections {
				if (collections.isEmpty || collections.contains(BskyCollection.post.description)) {
					settings.messageManager?.addMessageHandlerFilters(filterMessageHandler)
				}
			} else {
				settings.messageManager?.addMessageHandlerFilters(filterMessageHandler)
			}
		}
	
		return BskyFirehoseClient(settings: settings)
    }
}

extension DefaultFirehoseClientBuilder {
	@available(*, deprecated, renamed: "connect(to:)")
	public func withHost(_ server: FireshoseHost) -> Self {
		return connect(to: server)
	}
	
	@available(*, deprecated, renamed: "forCollections(_:)")
	public func withCollections(_ collection: [String]) -> Self {
		settings.set(collections: collection)
		return self
	}
	
	@available(*, deprecated, renamed: "withMaximumMessageSize(_:)")
	public func withMaximumMessageSize(_ size: MessageSize) -> Self {
		return maximumMessageSizeAllowed(size)
	}
	
	@available(*, deprecated, renamed: "messagesPlayback(since:)")
	public func withPlayback(_ playback: Playback) -> Self {
		return messagesPlayback(since: playback)
	}
	
	@available(*, deprecated, renamed: "compressionEnabled(_:)")
	public func withCompressionEnabled(_ value: Bool) -> Self {
		return compressionEnabled(value)
	}
	
	@available(*, deprecated, renamed: "useCustomMessageManager(_:)")
	public func withMessageManager(_ messageManager: any BskyMessageManager) -> Self {
		return useCustomMessageManager(messageManager)
	}
}
