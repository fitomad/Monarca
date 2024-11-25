//
//  CommitMessageHandler.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

actor CommitMessageHandler: Sendable {
	private(set) var nextHandler: (any BskyMessageHandler)?
}

extension CommitMessageHandler: BskyMessageHandler {
	func setNextHandler(_ handler: any BskyMessageHandler) {
		self.nextHandler = handler
	}
	
	func processMessage(content data: Data, using decoder: JSONDecoder) async throws -> BskyMessage {
		do {
			let commitMessage = try decoder.decode(BskyMessage.Commit.self, from: data)
			return .commit(payload: commitMessage)
		} catch let error {
			print("🚨 Commit\n\(String(data: data, encoding: .utf8) ?? "No data")")
			
			guard let nextHandler else {
				throw BskyMessageManagerError.unprocessable(message: data)
			}
			
			return try await nextHandler.processMessage(content: data, using: decoder)
		}
	}
}
