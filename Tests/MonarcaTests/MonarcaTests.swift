import Testing
@testable import Monarca

@Suite("Client tests. Conecction and message processing.")
struct MonarcaTests {
	@Test("Receive a message from the BlueSky Jetstream", .tags(.client))
	func testClientMessageReceived() async throws {
		let messageReceivedClosure: @Sendable (BskyMessage) -> Void = { message in
			#expect(true)
		}
		
		let bskyClient = try await DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withMessageManager(MockMessageManager())
			.onMessageReceived(messageReceivedClosure)
			.build()
		
		try await bskyClient.start()
	}
}

extension Tag {
	@Tag static var client: Tag
}

