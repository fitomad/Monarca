import Testing
@testable import Monarca

@Suite("Client tests. Conecction and message processing.")
struct MonarcaTests {
	@Test("Receive a message from the BlueSky Jetstream", .tags(.client))
	func testClientMessageReceived() async throws {
		let bskyClient = try DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withMessageManager(MockMessageManager())
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

