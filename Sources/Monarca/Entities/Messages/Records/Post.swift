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
		public let languages: [String]?
		public let text: String
		public let embeddedContent: Record.Post.Embedded?
		public let facets: [Record.Post.Facet]?
		public let reply: Record.Post.Reply?
		
		private enum CodingKeys: String, CodingKey {
			case createdAt
			case languages = "langs"
			case text
			case embeddedContent = "embed"
			case facets
			case reply
		}
	}
}

extension Record.Post {
	public struct Embedded: Codable, Sendable {
		public let images: [Record.Post.PostImage]?
		public let video: Record.Post.PostVideo?
		
		private enum CodingKeys: String, CodingKey {
			case images
			case video
		}
	}
	
	public struct PostImage: Codable, Sendable {
		public let alternateText: String?
		public let image: Record.Image
		public let aspectRatio: Record.AspectRatio?
		
		private enum CodingKeys: String, CodingKey {
			case alternateText = "alt"
			case image
			case aspectRatio
		}
	}
	
	public struct PostVideo: Codable, Sendable {
		public let alternateText: String?
		public let video: Record.Video
		public let aspectRatio: Record.AspectRatio?
		
		private enum CodingKeys: String, CodingKey {
			case alternateText = "alt"
			case video
			case aspectRatio
		}
	}
	
	public struct Reply: Codable, Sendable {
		public let parent: Record.LinkedIdentifier
		public let root: Record.LinkedIdentifier
	}
	
	public struct Facet: Codable, Sendable {
		public let features: [Record.Post.Facet.Feature]
		public let index: Record.Post.Facet.Index
		
		private enum CodingKeys: String, CodingKey {
			case features
			case index
		}
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			
			features = try values.decode([Record.Post.Facet.Feature].self, forKey: .features)
			index = try values.decode(Record.Post.Facet.Index.self, forKey: .index)
		}
	}
}

extension Record.Post.Facet {
	public struct Index: Codable, Sendable {
		let startIndex: Int
		let endIndex: Int
		
		private enum CodingKeys: String, CodingKey {
			case startIndex = "byteStart"
			case endIndex = "byteEnd"
		}
	}
	
	public enum Feature: Codable, Sendable {
		case link(_ value: String)
		case tag(_ value: String)
		case unknown
		
		private enum CodingKeys: String, CodingKey {
			case link = "uri"
			case tag
		}
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			
			if let link = try? values.decode(String.self, forKey: .link) {
				self = .link(link)
			} else if let tag = try? values.decode(String.self, forKey: .tag) {
				self = .tag(tag)
			} else {
				self = .unknown
			}
		}
	}
}
