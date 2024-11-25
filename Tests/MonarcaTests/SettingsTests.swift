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
		
		#expect(await settings.description.starts(with: "⚠️"))
	}
	
	@Test("", .tags(.settings))
	func testWithSingleLineDescriptionContent() async {
		let settings: BskyFirehoseSettings = await .defaultEastCoast
		
		let content = await settings.description
		
		#expect(content.starts(with: "Host"))
	}
	
	@Test("", .tags(.settings))
	func testWithTwoLinesDescriptionContent() async {
		let settings = BskyFirehoseSettings()
		await settings.set(host: .usaEast1)
		await settings.set(maximumMessageSize: .megabytes(value: 5))
		
		let content = await settings.description
		let newLineCharactersCount = content.filter(\.isNewline).count
		
		#expect(newLineCharactersCount == 1)
	}
	
	@Test("", .tags(.settings))
	func testWithMultipleLinesDescriptionContent() async {
		let settings = BskyFirehoseSettings()
		await settings.set(host: .usaEast1)
		await settings.set(maximumMessageSize: .megabytes(value: 5))
		await settings.set(playback: .milliseconds(5))
		await settings.set(collections: [ "Swift", "Vapor" ])
		await settings.set(isHelloRequired: false)
		await settings.set(decentralizedIdentifiers: [ "did:97531", "did:13579" ])
		await settings.set(isCompressionEnabled: false)
		
		let content = await settings.description
		let newLineCharactersCount = content.filter(\.isNewline).count
		print(content)
		#expect(newLineCharactersCount > 1)
	}
}

extension Tag {
	@Tag static var settings: Tag
}
