//
//  FilteredCommitMessageHandler.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 3/7/25.
//

import Foundation

actor FilteredCommitMessageHandler {
	private(set) var nextHandler: (any BskyMessageHandler)?
	private let filterTerm: String
	
	init(by term: String) {
		filterTerm = term
	}
}

extension FilteredCommitMessageHandler: BskyMessageHandler {
	func setNextHandler(_ handler: any BskyMessageHandler) {
		self.nextHandler = handler
	}
	
	func processMessage(content data: Data, using decoder: JSONDecoder) async throws -> BskyMessage {
		do {
			let commitMessage = try decoder.decode(BskyMessage.Commit.self, from: data)
			
			if case let .post(record) = commitMessage.payload.record, record.text.contains(filterTerm) {
				
			}
			
			return .commit(payload: commitMessage)
		} catch let error {
			guard let nextHandler else {
				throw BskyMessageManagerError.unprocessable(message: data)
			}
			
			return try await nextHandler.processMessage(content: data, using: decoder)
		}
	}
}
