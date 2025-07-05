//
//  SettingsTests.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation
import Testing

@testable import Monarca

@Suite("BskyFirehoseSettings tests")
struct SettingsTests {
	@Test("", .tags(.settings))
	func testEmptyDescription() async {
		let settings = BskyFirehoseSettings()
		
		let content = settings.description
		let newLineCharactersCount = content.filter(\.isNewline).count
		
		#expect(newLineCharactersCount == 0)
	}
	
	@Test("", .tags(.settings))
	func testWithSingleLineDescriptionContent() async {
		let settings: BskyFirehoseSettings = await .defaultEastCoast
		
		let content = settings.description
		
		#expect(content.starts(with: "Host"))
	}
	
	@Test("", .tags(.settings))
	func testWithTwoLinesDescriptionContent() async {
		var settings = BskyFirehoseSettings()
		settings.set(host: .usaEast1)
		settings.set(maximumMessageSize: .megabytes(value: 5))
		
		let content = settings.description
		let newLineCharactersCount = content.filter(\.isNewline).count
		
		#expect(newLineCharactersCount == 2)
	}
	
	@Test("", .tags(.settings))
	func testWithMultipleLinesDescriptionContent() async {
		var settings = BskyFirehoseSettings()
		settings.set(host: .usaEast1)
		settings.set(maximumMessageSize: .megabytes(value: 5))
		settings.set(playback: .milliseconds(5))
		settings.set(collections: [ "Swift", "Vapor" ])
		settings.set(isHelloRequired: false)
		settings.set(decentralizedIdentifiers: [ "did:97531", "did:13579" ])
		settings.set(isCompressionEnabled: false)
		
		let content = settings.description
		let newLineCharactersCount = content.filter(\.isNewline).count
		print(content)
		#expect(newLineCharactersCount > 1)
	}
}

extension Tag {
	@Tag static var settings: Tag
}
