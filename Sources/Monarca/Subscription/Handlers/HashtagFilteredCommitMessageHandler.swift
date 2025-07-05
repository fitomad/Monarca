import Foundation

struct HashtagFilteredCommitMessageHandler {
	private(set) var nextHandler: (any BskyMessageHandler)?
	private let hashtags: [String]
	
	init(by hashtags: [String[]) {
		self.hashtags = hashtags
	}
}

extension HashtagFilteredCommitMessageHandler: BskyMessageHandler {
	mutating func setNextHandler(_ handler: any BskyMessageHandler) {
		self.nextHandler = handler
	}
	
	mutating func processMessage(content data: Data, using decoder: JSONDecoder) async throws -> BskyMessage {
		do {
			let commitMessage = try decoder.decode(BskyMessage.Commit.self, from: data)
			
			if case let .post(record) = commitMessage.payload.record, record.text.contains(filterTerm) {
				
			}
			
			return .commit(payload: commitMessage)
		} catch {
			guard var nextHandler else {
				throw BskyMessageManagerError.unprocessable(message: data)
			}
			
			return try await nextHandler.processMessage(content: data, using: decoder)
		}
	}
}
