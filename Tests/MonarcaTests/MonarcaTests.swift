import Testing
@testable import Monarca

@Suite("Client tests. Conecction and message processing.")
struct MonarcaTests {
	@Test("Connect and close Jetstream connection", .tags(.client))
	func testClientConnectionAndCloseConnection() async throws {
		let bskyClient = BskyFirehoseClient(settings: .defaultEastCoast)
		
		try bskyClient.start()
		#expect(bskyClient.isConnected)
		
		bskyClient.stop()
		#expect(bskyClient.isConnected == false)
	}
	
	@Test("Receive a message from the BlueSky Jetstream", .tags(.client))
	func testClientMessageReceived() async throws {
		let bskyClient = BskyFirehoseClient(settings: .defaultEastCoast)
		
		bskyClient.onMessageReceived { message in
			print(message)
			#expect(true)
		}
		
		try bskyClient.start()
		#expect(bskyClient.isConnected)
	}
}

extension Tag {
	@Tag static var client: Tag
}

