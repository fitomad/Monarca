//
//  StarterPack.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 26/11/24.
//

import Foundation

extension Record {
	public struct StarterPack: Codable, Sendable {
		public let createdAt: Date
		public let description: String?
		public let listBskyLink: String
		public let name: String
		public let updatedAt: Date?
		public let feedBskyLinks: [String]
		
		private enum CodingKeys: String, CodingKey {
			case createdAt
			case description
			case listBskyLink = "list"
			case name
			case updatedAt
			case feedBskyLinks = "feeds"
		}
		
		public init(from decoder: any Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			
			self.createdAt = try container.decode(Date.self, forKey: .createdAt)
			self.description = try? container.decode(String.self, forKey: .description)
			self.listBskyLink = try container.decode(String.self, forKey: .listBskyLink)
			self.name = try container.decode(String.self, forKey: .name)
			self.updatedAt = try? container.decode(Date.self, forKey: .updatedAt)
			let feeds = try container.decode([Record.StarterPack.FeedLink].self, forKey: .feedBskyLinks)
			self.feedBskyLinks = feeds.map(\.uri)
		}
	}
}

extension Record.StarterPack {
	private struct FeedLink: Decodable {
		let uri: String
	}
}
