import Testing
@testable import Monarca

@Suite("Client tests. Conecction and message processing.")
struct MonarcaTests {
	@Test("Receive a message from the BlueSky Jetstream", .tags(.client))
	func testClientMessageReceived() async throws {
		let bskyClient = try DefaultFirehoseClientBuilder()
			.connect(to: .usaEast1)
			.useCustomMessageManager(MockMessageManager())
			.build()
		
		await bskyClient.onMessageReceived { message in
			#expect(true)
		}
		
		try await bskyClient.start()
	}
}

extension Tag {
	@Tag static var client: Tag
}

