import Testing
@testable import Monarca

@Suite("Client tests. Conecction and message processing.")
struct MonarcaTests {
	@Test("Open and close connection to BlueSky Jetstream", .tags(.client))
	func testClientConnectionAndCloseConnection() async throws {
		let bskyClient = BskyFirehoseClient(settings: .defaultEastCoast)
		
		let openTask = Task {
			try await bskyClient.start()
			#expect(await bskyClient.isConnected)
		}
		
		await openTask.result
		
		let closeTask = Task {
			await bskyClient.stop()
			#expect(await bskyClient.isConnected == false)
		}
		
		await closeTask.result
	}
	
	@Test("Receive a message", .tags(.client))
	func testMessageReceived() async throws {
		let bskyClient = BskyFirehoseClient(settings: .defaultEastCoast)
		
		let openTask = Task {
			try await bskyClient.start()
			#expect(await bskyClient.isConnected)
		}
		
		await openTask.result
		
		let messageTask = Task {
			await bskyClient.onMessageReceived { message in
				print(message)
				#expect(true)
			}
		}
		
		await messageTask.result
		
		await bskyClient.stop()
	}
}

extension Tag {
	@Tag static var client: Tag
}

