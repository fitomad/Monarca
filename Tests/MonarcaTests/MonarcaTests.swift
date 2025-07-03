import Testing
@testable import Monarca

@Suite("Client tests. Conecction and message processing.")
struct MonarcaTests {
	//@Test("Connect and close Jetstream connection", .tags(.client))
	func testClientConnectionAndCloseConnection() async throws {
		let bskyClient = try await DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withMessageManager(MockMessageManager())
			.build()
		
		try await bskyClient.start()
		#expect(await bskyClient.isConnected)
		
		await bskyClient.stop()
		#expect(await bskyClient.isConnected == false)
	}
	
	@Test("Receive a message from the BlueSky Jetstream", .tags(.client))
	func testClientMessageReceived() async throws {
		let bskyClient = try await DefaultFirehoseClientBuilder()
			.withHost(.usaEast1)
			.withMessageManager(MockMessageManager())
			.build()
		
		await bskyClient.onMessageReceived { message in
			print("📣 \(message)")
			#expect(true)
		}
		
		try await bskyClient.start()
		#expect(await bskyClient.isConnected)
	}
}

extension Tag {
	@Tag static var client: Tag
}

