//
//  HashtagFilteredCommitMessageHandler.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 4/7/25.
//


import Foundation

struct HashtagFilteredCommitMessageHandler {
	private(set) var nextHandler: (any BskyMessageHandler)?
	private let hashtags: Set<String>
	
	init(by hashtags: [String]) {
		self.hashtags = Set(hashtags)
	}
}

extension HashtagFilteredCommitMessageHandler: BskyMessageHandler {
	mutating func setNextHandler(_ handler: any BskyMessageHandler) {
		self.nextHandler = handler
	}
	
	mutating func processMessage(content data: Data, using decoder: JSONDecoder) async throws -> BskyMessage {
		do {
			let commitMessage = try decoder.decode(BskyMessage.Commit.self, from: data)
			
			if case let .post(record) = commitMessage.payload.record {
				let postHashtags = record.facets?.map { facet in
					let hashtags = facet.features.compactMap { feature in
						if case let .tag(value) = feature {
							return value
						}
						
						return nil
					}
					
					return hashtags
				}
				.flatMap { $0 } ?? []
				
				if hashtags.intersection(postHashtags).isEmpty {
					throw BskyMessageHandlerError.noHashtagMatch
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
