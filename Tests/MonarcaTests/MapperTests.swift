//
//  MapperTests.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 22/11/24.
//

import Foundation
import Testing
@testable import Monarca

@Suite("Mapper from settings to URL tests")
struct MapperTests {
	@Test("", .tags(.mapper))
	func testMapperUnavailableURL() async throws {
		await #expect(throws: FirehoseMapperError.malformedParameterURL) {
			let settings = BskyFirehoseSettings()
			let mapper = BskyFirehoseSettingsMapper()
			
			let _ = try await mapper.mapToURL(from: settings)
		}
	}
	
	@Test("", .tags(.mapper))
	func testMapperURL() async throws {
		let settings = BskyFirehoseSettings()
		await settings.set(host: .usaEast1)
		
		let mapper = BskyFirehoseSettingsMapper()
			
		let url = try await mapper.mapToURL(from: settings)
		
		#expect(url.absoluteString == FireshoseHost.usaEast1.endpoint)
	}
	
	@Test("", .tags(.mapper))
	func testMapperSigleValuesInCollectionsURL() async throws {
		let settings = BskyFirehoseSettings()
		await settings.set(host: .usaEast1)
		await settings.set(collections: [ "swift" ])
		await settings.set(decentralizedIdentifiers: [ "did:97531" ])
		
		let mapper = BskyFirehoseSettingsMapper()
			
		let url = try await mapper.mapToURL(from: settings)
		
		#expect(url.absoluteString == Constants.singleCollectionElementsURL)
	}
	
	@Test("", .tags(.mapper))
	func testMapperMultipleValuesInCollectionsURL() async throws {
		let settings = BskyFirehoseSettings()
		await settings.set(host: .usaEast1)
		await settings.set(collections: [ "swift" ])
		await settings.set(decentralizedIdentifiers: [ "did:97531" ])
		
		let mapper = BskyFirehoseSettingsMapper()
			
		let url = try await mapper.mapToURL(from: settings)
		
		#expect(url.absoluteString == Constants.singleCollectionElementsURL)
	}
	
	@Test("", .tags(.mapper))
	func testMapperFullParametersURL() async throws {
		let settings = BskyFirehoseSettings()
		await settings.set(host: .usaEast1)
		await settings.set(collections: [ "swift", "objc" ])
		await settings.set(decentralizedIdentifiers: [ "did:97531", "did:13579" ])
		await settings.set(playback: .seconds(5))
		await settings.set(maximumMessageSize: .kilobytes(value: 2))
		await settings.set(isCompressionEnabled: false)
		await settings.set(isHelloRequired: false)
		
		let mapper = BskyFirehoseSettingsMapper()
			
		let url = try await mapper.mapToURL(from: settings)
		
		let regex = try Regex(Constants.fullParameterRegEx)
		let match = try regex.firstMatch(in: url.absoluteString)
			
		#expect(match != nil)
	}
}

extension Tag {
	@Tag static var mapper: Tag
}

extension MapperTests {
	fileprivate enum Constants {
		static let singleCollectionElementsURL = "wss://jetstream1.us-east.bsky.network/subscribe?wantedCollections=swift&wantedDids=did:97531"
		static let multipleCollectionElementsURL = "wss://jetstream1.us-east.bsky.network/subscribe?wantedCollections=swift&wantedCollections=objc&wantedDids=did:97531&wantedDids=did:13579"
		static let fullParameterRegEx = #"wss\:\/\/jetstream1\.us-east\.bsky\.network\/subscribe\?wantedCollections\=swift\&wantedCollections\=objc\&wantedDids\=did\:97531\&wantedDids\=did\:13579\&compress\=false\&cursor=\d{1,}\&maxMessageSizeBytes\=2048\&requireHello\=false"#
	}
}
