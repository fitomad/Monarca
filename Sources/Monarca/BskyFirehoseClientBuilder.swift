//
//  BskyFirehoseClientBuilder.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//


public protocol BskyFirehoseClientBuilder {
	@available(*, deprecated, renamed: "connect(to:)")
    func withHost(_ server: FireshoseHost) -> Self
	func connect(to host: FireshoseHost) -> Self
	@available(*, deprecated, renamed: "forCollections(_:)")
	func withCollections(_ collection: [String]) -> Self
	func forCollections(_ collection: [BskyCollection]) -> Self
	func withDecentralizedIdentifiers(_ identifiers: [String]) -> Self
	@available(*, deprecated, renamed: "withMaximumMessageSize(_:)")
	func withMaximumMessageSize(_ size: MessageSize) -> Self
	func maximumMessageSizeAllowed(_ size: MessageSize) -> Self
	@available(*, deprecated, renamed: "messagesPlayback(since:)")
	func withPlayback(_ playback: Playback) -> Self
	func messagesPlayback(since moment: Playback) -> Self
	@available(*, deprecated, renamed: "compressionEnabled(_:)")
	func withCompressionEnabled(_ value: Bool) -> Self
	func compressionEnabled(_ value: Bool) -> Self
	func withHelloExecution(_ value: Bool) -> Self
	@available(*, deprecated, renamed: "useCustomMessageManager(_:)")
	func withMessageManager(_ messageManager: BskyMessageManager) -> Self
	func useCustomMessageManager(_ messageManager: BskyMessageManager) -> Self
	func dedicatedThreads(count: Int) -> Self
	func applyContentFilter(by terms: [String]) -> Self
	func applyHashtagFilter(by hashtags: [String]) -> Self
    
    func reset()
	func build() throws -> BskyFirehoseClient
}
