//
//  FirehoseClientBuilderTests.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation
import Testing
@testable import Monarca

@Suite("BskyFirehose client builder")
struct BuilderTests {
	@Test("Default builder", .tags(.builder))
	func testDefaultBuilding() async throws {
		await #expect(throws: BskyFirehoseError.invalidConnectionParameters) {
			let _ = try await DefaultFirehoseClientBuilder().build()
		}
	}
	
	@Test("Client with specific server", .tags(.builder), arguments: Constants.serverList)
	func testClientURL(server: FirehoseHost) async throws {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: server)
			.build()
		
		#expect(await firehoseClient.settings.host != nil)
		#expect(await firehoseClient.settings.host!.endpoint == server.endpoint)
	}
	
	@Test("Client with custom server", .tags(.builder), arguments: Constants.customServerList)
	func testClientCustomURL(_ custom: FirehoseHost) async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: custom)
			.build()
		
		#expect(await firehoseClient.settings.host != nil)
		#expect(await firehoseClient.settings.host!.endpoint == custom.endpoint)
	}
	
	@Test("Client with specific Server + Collection set empty", .tags(.builder))
	func testClientCollections() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.forCollections([BskyCollection]())
			.build()
		
		#expect(await firehoseClient.settings.collections != nil)
		#expect(await firehoseClient.settings.collections!.isEmpty)
	}
	
	@Test("Client with specific Server + Collection set fake", .tags(.builder))
	func testClientCustomCollections() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.withCollections([ "a", "b", "c" ])
			.build()
		
		#expect(await firehoseClient.settings.collections != nil)
		#expect(await firehoseClient.settings.collections!.count == 3)
		#expect(await firehoseClient.settings.collections!.contains("a"))
		#expect(await firehoseClient.settings.collections!.contains("b"))
		#expect(await firehoseClient.settings.collections!.contains("c"))
	}
	
	@Test("Client with specific Server + Collection set", .tags(.builder))
	func testClientBskyCollections() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.forCollections([ .post, .like, .repost ])
			.build()
		
		#expect(await firehoseClient.settings.collections != nil)
		#expect(await firehoseClient.settings.collections!.count == 3)
		#expect(await firehoseClient.settings.collections!.contains(BskyCollection.post.description))
		#expect(await firehoseClient.settings.collections!.contains(BskyCollection.like.description))
		#expect(await firehoseClient.settings.collections!.contains(BskyCollection.repost.description))
	}
	
	@Test("Client with specific Server + decentralized ID empty", .tags(.builder))
	func testClientIdentifiers() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.withDecentralizedIdentifiers([])
			.build()
		
		#expect(await firehoseClient.settings.decentralizedIdentifiers != nil)
		#expect(await firehoseClient.settings.decentralizedIdentifiers!.isEmpty)
	}
	
	@Test("Client with specific Server + decentralized ID", .tags(.builder))
	func testClientCustomIdentifiers() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.withDecentralizedIdentifiers(Constants.customIdentifierList)
			.build()
		
		#expect(await firehoseClient.settings.decentralizedIdentifiers != nil)
		#expect(await firehoseClient.settings.decentralizedIdentifiers!.count == Constants.customIdentifierList.count)
	}
	
	@Test("Client with specific Server + Compression enabled", .tags(.builder))
	func testClientCompressionEnabled() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.compressionEnabled(true)
			.build()
		
		#expect(await firehoseClient.settings.isCompressionEnabled != nil)
		#expect(await firehoseClient.settings.isCompressionEnabled!)
	}
	
	@Test("Client with specific Server + Compression disabled", .tags(.builder))
	func testClientCompressionDisabled() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.compressionEnabled(false)
			.build()
		
		#expect(await firehoseClient.settings.isCompressionEnabled != nil)
		#expect(await firehoseClient.settings.isCompressionEnabled! == false)
	}
	
	@Test("Client with specific Server + Hello", .tags(.builder))
	func testClientHelloCommandEnabled() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.withHelloExecution(true)
			.build()
		
		#expect(await firehoseClient.settings.isHelloRequired != nil)
		#expect(await firehoseClient.settings.isHelloRequired!)
	}
	
	@Test("Client with specific Server + Hello false", .tags(.builder))
	func testClientHelloCommandDisabled() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.withHelloExecution(false)
			.build()
		
		#expect(await firehoseClient.settings.isHelloRequired != nil)
		#expect(await firehoseClient.settings.isHelloRequired! == false)
	}
	
	@Test("Client with specific Server + Maximum message size", .tags(.builder), arguments: Constants.messagesSizeList)
	func testMessageSizeLimit(testSet: (sut: MessageSize, expectedValue: Int)) async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.maximumMessageSizeAllowed(testSet.sut)
			.build()
		
		#expect(await firehoseClient.settings.maximumMessageSize != nil)
		#expect(await firehoseClient.settings.maximumMessageSize! == testSet.expectedValue)
	}
	
	@Test("Client with specific Server + Playback", .tags(.builder), arguments: Constants.playbackList)
	func testMessagePlayback(sut: Playback) async throws  {
		let currentEpochTimestamp = Int(Date().timeIntervalSince1970)
		let lowEpochBound = currentEpochTimestamp - 50_0000
		let maxEpochBound = currentEpochTimestamp + 50_0000
		
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.messagesPlayback(since: sut)
			.build()
		
		#expect(await firehoseClient.settings.playback != nil)
		#expect(await firehoseClient.settings.playback!.timeValue > lowEpochBound)
		#expect(await firehoseClient.settings.playback!.timeValue < maxEpochBound)
	}
	
	@Test("Client with specific Server + Custom message handler", .tags(.builder))
	func testClientMessageManager() async throws  {
		let mockMessageManager = MockMessageManager()
		let builder = DefaultFirehoseClientBuilder()
		
		let firehoseClient = try builder
			.connect(to: .usaEast1)
			.useCustomMessageManager(mockMessageManager)
			.build()
		
		#expect(await firehoseClient.settings.messageManager != nil)
		
		if let testableManager = await firehoseClient.settings.messageManager as? TestableMessageManager {
			#expect(testableManager.filtersCount == 0)
		} else {
			#expect(false, "Default message manager is not TestableMessageManager")
		}
	}
	
	@Test("Client with specific Server + Dedicated threads", .tags(.builder))
	func testDedicatedThreads() async throws  {
		let builder = DefaultFirehoseClientBuilder()
		
		let firehoseClient = try builder
			.connect(to: .usaEast1)
			.dedicatedThreads(count: 10)
			.build()
		
		#expect(await firehoseClient.settings.dedicatedThreads == 10)
	}
	
	@Test("Client with specific Server + Hastag filter", .tags(.builder))
	func testFilterHashtagManagerHandlerCount() async throws {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.applyHashtagFilter(by: [ "Madrid" ])
			.build()
		
		if let testableManager = await firehoseClient.settings.messageManager as? TestableMessageManager {
			#expect(testableManager.filtersCount == 4)
		} else {
			#expect(false, "Default message manager is not TestableMessageManager")
		}
	}
	
	@Test("Client with specific Server + Content filte", .tags(.builder))
	func testFilterContentManagerHandlerCount() async throws {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.applyContentFilter(by: [ "Madrid" ])
			.build()
		
		if let testableManager = await firehoseClient.settings.messageManager as? TestableMessageManager {
			#expect(testableManager.filtersCount == 4)
		} else {
			#expect(false, "Default message manager is not TestableMessageManager")
		}
	}
	
	@Test("Client with specific Server + Hastag filte + Content filte", .tags(.builder))
	func testFilterHashtagAndContentManagerHandlerCount() async throws {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.applyHashtagFilter(by: [ "Madrid" ])
			.applyContentFilter(by: [ "España" ])
			.build()
		
		if let testableManager = await firehoseClient.settings.messageManager as? TestableMessageManager {
			#expect(testableManager.filtersCount == 5)
		} else {
			#expect(false, "Default message manager is not TestableMessageManager")
		}
	}
	
	@Test("Client with all settings", .tags(.builder))
	func testBuilderReset() async throws  {
		let builder = DefaultFirehoseClientBuilder()
		
		var firehoseClient  = try builder
			.connect(to: .usaEast1)
			.forCollections([ .post, .repost, .like ])
			.withDecentralizedIdentifiers(Constants.customIdentifierList)
			.compressionEnabled(false)
			.withHelloExecution(false)
			.maximumMessageSizeAllowed(.kilobytes(value: 2048))
			.messagesPlayback(since: .seconds(5))
			.dedicatedThreads(count: 8)
			.build()
			
		#expect(await firehoseClient.settings.host != nil)
		#expect(await firehoseClient.settings.collections != nil)
		#expect(await firehoseClient.settings.decentralizedIdentifiers != nil)
		#expect(await firehoseClient.settings.isCompressionEnabled != nil)
		#expect(await firehoseClient.settings.isHelloRequired != nil)
		#expect(await firehoseClient.settings.maximumMessageSize != nil)
		#expect(await firehoseClient.settings.playback != nil)
		#expect(await firehoseClient.settings.dedicatedThreads == 8)
		
		builder.reset()
		
		firehoseClient = try builder
			.connect(to: .usaEast1)
			.build()
		
		#expect(await firehoseClient.settings.host != nil)
		#expect(await firehoseClient.settings.collections == nil)
		#expect(await firehoseClient.settings.decentralizedIdentifiers == nil)
		#expect(await firehoseClient.settings.isCompressionEnabled == nil)
		#expect(await firehoseClient.settings.isHelloRequired == nil)
		#expect(await firehoseClient.settings.maximumMessageSize == nil)
		#expect(await firehoseClient.settings.playback == nil)
		#expect(await firehoseClient.settings.dedicatedThreads == 2)
	}
}

extension Tag {
	@Tag static var builder: Self
}

fileprivate enum Constants {
	static var serverList: [FirehoseHost] {
		[
			FirehoseHost.usaEast1,
			FirehoseHost.usaWest1,
			FirehoseHost.usaEast2,
			FirehoseHost.usaWest2,
		]
	}
	
	static var customServerList: [FirehoseHost] {
		[
			.custom(server: "https://apple.com"),
			.custom(server: "https://developer.apple.com"),
			.custom(server: "https://bsky.app"),
			.custom(server: "https://medium.com"),
			.custom(server: "ws://example.com"),
			.custom(server: "wss://example.com")
		]
	}
	
	static var customIdentifierList: [String] {
		[
			"@fitomad.bsky.social",
			"@museodelprado.es",
			"@bsky.app",
			"@atproto.com"
		]
	}
	
	static var messagesSizeList: [(MessageSize, Int)] {
		[
			(MessageSize.bytes(value: 100), 100),
			(MessageSize.kilobytes(value: 1), 1024),
			(MessageSize.megabytes(value: 1), 1_048_576),
			(MessageSize.unlimited, 0)
		]
	}
	
	static var playbackList: [Playback] {
		[
			Playback.now,
			Playback.milliseconds(100),
			Playback.seconds(15),
			Playback.minutes(3)
		]
	}
}
