//
//  Post.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension Record {
	public struct Post: Codable, Sendable {
		public let createdAt: Date
		public let languages: [String]
		public let text: String
		public let embeddedContent: Record.Post.Embedded?
		public let reply: Record.Post.Reply?
		
		private enum CodingKeys: String, CodingKey {
			case createdAt
			case languages = "langs"
			case text
			case embeddedContent = "embed"
			case reply
		}
	}
}

extension Record.Post {
	public struct Embedded: Codable, Sendable {
		public let images: [Record.Post.PostImage]?
		
		private enum CodingKeys: String, CodingKey {
			case images
		}
	}
	
	public struct PostImage: Codable, Sendable {
		public let alternateText: String?
		public let image: Record.Image
		public let aspectRatio: Record.AspectRatio
		
		private enum CodingKeys: String, CodingKey {
			case alternateText = "alt"
			case image
			case aspectRatio
		}
	}
	
	public struct Reply: Codable, Sendable {
		public let parent: Record.LinkedIdentifier
		public let root: Record.LinkedIdentifier
	}
}
