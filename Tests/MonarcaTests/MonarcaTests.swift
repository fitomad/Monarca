import Testing
@testable import Monarca

@Suite("Client tests. Conecction and message processing.")
struct MonarcaTests {
	@Test("", .tags(.client))
	func testClientConnectionAndCloseConnection() async throws {
		let bskyClient = BskyFirehoseClient(settings: .defaultEastCoast)
		
		//Task(priority: .background) {
		try bskyClient.start()
		#expect(bskyClient.isConnected)
		//}
		
		bskyClient.stop()
		#expect(bskyClient.isConnected == false)
	}
}

extension Tag {
	@Tag static var client: Tag
}

