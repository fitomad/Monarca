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
struct BuilerTests {
	@Test("", .tags(.builder))
	func testDefaultBuilding() async throws {
		#expect(throws: BskyFirehoseError.invalidConnectionParameters) {
			let _ = try DefaultFirehoseClientBuilder().build()
		}
	}
	
	@Test("", .tags(.builder), arguments: Constants.serverList)
	func testClientURL(server: FireshoseHost) async throws {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(server)
			.build()
		
		#expect(firehoseClient.settings.host != nil)
		#expect(firehoseClient.settings.host!.endpoint == server.endpoint)
	}
	
	@Test("", .tags(.builder), arguments: Constants.customServerList)
	func testClientCustomURL(_ custom: FireshoseHost) async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(custom)
			.build()
		
		#expect(firehoseClient.settings.host != nil)
		#expect(firehoseClient.settings.host!.endpoint == custom.endpoint)
	}
	
	@Test("", .tags(.builder))
	func testClientCollections() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withCollections([])
			.build()
		
		#expect(firehoseClient.settings.collections != nil)
		#expect(firehoseClient.settings.collections!.isEmpty)
	}
	
	@Test("", .tags(.builder))
	func testClientCustomCollections() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withCollections([ "a", "b", "c" ])
			.build()
		
		#expect(firehoseClient.settings.collections != nil)
		#expect(firehoseClient.settings.collections!.count == 3)
		#expect(firehoseClient.settings.collections!.contains("a"))
		#expect(firehoseClient.settings.collections!.contains("b"))
		#expect(firehoseClient.settings.collections!.contains("c"))
	}
	
	@Test("", .tags(.builder))
	func testClientIdentifiers() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withDecentralizedIdentifiers([])
			.build()
		
		#expect(firehoseClient.settings.decentralizedIdentifiers != nil)
		#expect(firehoseClient.settings.decentralizedIdentifiers!.isEmpty)
	}
	
	@Test("", .tags(.builder))
	func testClientCustomIdentifiers() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withDecentralizedIdentifiers(Constants.customIdentifierList)
			.build()
		
		#expect(firehoseClient.settings.decentralizedIdentifiers != nil)
		#expect(firehoseClient.settings.decentralizedIdentifiers!.count == Constants.customIdentifierList.count)
	}
	
	@Test("", .tags(.builder))
	func testClientCompressionEnabled() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withCompressionEnabled(true)
			.build()
		
		#expect(firehoseClient.settings.isCompressionEnabled != nil)
		#expect(firehoseClient.settings.isCompressionEnabled!)
	}
	
	@Test("", .tags(.builder))
	func testClientCompressionDisabled() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withCompressionEnabled(false)
			.build()
		
		#expect(firehoseClient.settings.isCompressionEnabled != nil)
		#expect(firehoseClient.settings.isCompressionEnabled! == false)
	}
	
	@Test("", .tags(.builder))
	func testClientHelloCommandEnabled() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withHelloExecution(true)
			.build()
		
		#expect(firehoseClient.settings.isHelloRequired != nil)
		#expect(firehoseClient.settings.isHelloRequired!)
	}
	
	@Test("", .tags(.builder))
	func testClientHelloCommandDisabled() async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withHelloExecution(false)
			.build()
		
		#expect(firehoseClient.settings.isHelloRequired != nil)
		#expect(firehoseClient.settings.isHelloRequired! == false)
	}
	
	@Test("", .tags(.builder), arguments: Constants.messagesSizeList)
	func testMessageSizeLimit(testSet: (sut: MessageSize, expectedValue: Int)) async throws  {
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withMaximumMessageSize(testSet.sut)
			.build()
		
		#expect(firehoseClient.settings.maximumMessageSize != nil)
		#expect(firehoseClient.settings.maximumMessageSize! == testSet.expectedValue)
	}
	
	@Test("", .tags(.builder), arguments: Constants.playbackList)
	func testMessagePlayback(sut: Playback) async throws  {
		let currentEpochTimestamp = Int(Date().timeIntervalSince1970)
		let lowEpochBound = currentEpochTimestamp - 50_0000
		let maxEpochBound = currentEpochTimestamp + 50_0000
		
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withPlayback(sut)
			.build()
		
		#expect(firehoseClient.settings.playback != nil)
		#expect(firehoseClient.settings.playback!.timeValue > lowEpochBound)
		#expect(firehoseClient.settings.playback!.timeValue < maxEpochBound)
	}
	
	@Test("", .tags(.builder))
	func testClientMessageManager() async throws  {
		let mockMessageManager = MockMessageManager()
		
		let firehoseClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withMessageManager(mockMessageManager)
			.build()
	}
	
	@Test("", .tags(.builder))
	func testBuilderReset() async throws  {
		let builder = DefaultFirehoseClientBuilder()
		
		var firehoseClient = try builder
			.withHost(.usaEast1)
			.withCollections([ "a", "b", "c" ])
			.withDecentralizedIdentifiers(Constants.customIdentifierList)
			.withCompressionEnabled(false)
			.withHelloExecution(false)
			.withMaximumMessageSize(.kilobytes(value: 2048))
			.withPlayback(.seconds(5))
			.build()
			
		
		#expect(firehoseClient.settings.host != nil)
		#expect(firehoseClient.settings.collections != nil)
		#expect(firehoseClient.settings.decentralizedIdentifiers != nil)
		#expect(firehoseClient.settings.isCompressionEnabled != nil)
		#expect(firehoseClient.settings.isHelloRequired != nil)
		#expect(firehoseClient.settings.maximumMessageSize != nil)
		#expect(firehoseClient.settings.playback != nil)
		
		builder.reset()
		
		firehoseClient = try builder
			.withHost(.usaEast1)
			.build()
		
		#expect(firehoseClient.settings.host != nil)
		#expect(firehoseClient.settings.collections == nil)
		#expect(firehoseClient.settings.decentralizedIdentifiers == nil)
		#expect(firehoseClient.settings.isCompressionEnabled == nil)
		#expect(firehoseClient.settings.isHelloRequired == nil)
		#expect(firehoseClient.settings.maximumMessageSize == nil)
		#expect(firehoseClient.settings.playback == nil)
	}
}

extension Tag {
	@Tag static var builder: Self
}

fileprivate enum Constants {
	static var serverList: [FireshoseHost] {
		[
			FireshoseHost.usaEast1,
			FireshoseHost.usaWest1,
			FireshoseHost.usaEast2,
			FireshoseHost.usaWest2,
		]
	}
	
	static var customServerList: [FireshoseHost] {
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

extension BuilerTests {
	struct MockMessageManager: BskyMessageManager {
		func processMessage(content data: Data) throws -> BskyMessage {
			.commit
		}
		
		func processMessage(string value: String) throws -> BskyMessage {
			.commit
		}
	}
}
