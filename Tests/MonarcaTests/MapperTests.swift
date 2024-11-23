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
	func testMapperUnavailableURL() throws {
		#expect(throws: FirehoseMapperError.malformedParameterURL) {
			let settings = BskyFirehoseSettings()
			let mapper = BskyFirehoseSettingsMapper()
			
			let url = try mapper.mapToURL(from: settings)
		}
	}
	
	@Test("", .tags(.mapper))
	func testMapperURL() throws {
		let settings = BskyFirehoseSettings(host: .usaEast1)
		let mapper = BskyFirehoseSettingsMapper()
			
		let url = try mapper.mapToURL(from: settings)
		
		#expect(url.absoluteString == FireshoseHost.usaEast1.endpoint)
	}
	
	@Test("", .tags(.mapper))
	func testMapperSigleValuesInCollectionsURL() throws {
		let settings = BskyFirehoseSettings(
			host: .usaEast1,
			collections: [ "swift" ],
			decentralizedIdentifiers: [ "did:97531" ]
		)
		
		let mapper = BskyFirehoseSettingsMapper()
			
		let url = try mapper.mapToURL(from: settings)
		
		#expect(url.absoluteString == Constants.singleCollectionElementsURL)
	}
	
	@Test("", .tags(.mapper))
	func testMapperMultipleValuesInCollectionsURL() throws {
		let settings = BskyFirehoseSettings(
			host: .usaEast1,
			collections: [ "swift", "objc" ],
			decentralizedIdentifiers: [ "did:97531", "did:13579" ]
		)
		
		let mapper = BskyFirehoseSettingsMapper()
			
		let url = try mapper.mapToURL(from: settings)
		
		#expect(url.absoluteString == Constants.multipleCollectionElementsURL)
	}
	
	@Test("", .tags(.mapper))
	func testMapperFullParametersURL() throws {
		let settings = BskyFirehoseSettings(
			host: .usaEast1,
			collections: [ "swift", "objc" ],
			decentralizedIdentifiers: [ "did:97531", "did:13579" ],
			maximumMessageSize: .kilobytes(value: 2),
			playback: .seconds(5),
			isCompressionEnabled: false,
			isHelloRequired: false
		)
		
		let mapper = BskyFirehoseSettingsMapper()
			
		let url = try mapper.mapToURL(from: settings)
		
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
