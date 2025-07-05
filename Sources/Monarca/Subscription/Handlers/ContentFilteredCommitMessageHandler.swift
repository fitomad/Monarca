//
//  FilteredCommitMessageHandler.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 3/7/25.
//

import Foundation

struct ContentFilteredCommitMessageHandler {
	private(set) var nextHandler: (any BskyMessageHandler)?
	private let filterTerms: Set<String>
	
	init(by terms: [String]) {
		filterTerms = Set(terms)
	}
}

extension ContentFilteredCommitMessageHandler: BskyMessageHandler {
	mutating func setNextHandler(_ handler: any BskyMessageHandler) {
		self.nextHandler = handler
	}
	
	mutating func processMessage(content data: Data, using decoder: JSONDecoder) async throws -> BskyMessage {
		do {
			let commitMessage = try decoder.decode(BskyMessage.Commit.self, from: data)
			
			if case let .post(record) = commitMessage.payload.record {
				let postTokens = record.text.split(separator: " ")
											.map { String($0) }
				
				if filterTerms.intersection(postTokens).isEmpty {
					throw BskyMessageHandlerError.noContentMatch
				}
				
				return .commit(payload: commitMessage)
			}
			
			throw BskyMessageHandlerError.noPostCommitMessage
		} catch {
			guard var nextHandler else {
				throw BskyMessageManagerError.unprocessable(message: data)
			}
			
			return try await nextHandler.processMessage(content: data, using: decoder)
		}
	}
}
