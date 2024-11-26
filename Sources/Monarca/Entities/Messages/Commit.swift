//
//  Commit.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension BskyMessage {
	public struct Commit: Codable, Sendable {
		let did: String
		let createdAt: Int
		let kind: String
		let payload: BskyMessage.Commit.Payload
		
		private enum CodingKeys: String, CodingKey {
			case did
			case createdAt = "time_us"
			case kind
			case payload = "commit"
		}
	}
}

extension BskyMessage.Commit {
	public struct Payload: Codable, Sendable {
		let cid: String?
		let operation: BskyMessage.Commit.Operation
		let collection: Collection
		let relatedKey: String
		let record: Record?
		
		private enum CodingKeys: String, CodingKey {
			case cid
			case operation
			case collection
			case relatedKey = "rkey"
			case record
		}
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			
			cid = try? values.decode(String.self, forKey: .cid)
			operation = try values.decode(BskyMessage.Commit.Operation.self, forKey: .operation)
			relatedKey = try values.decode(String.self, forKey: .relatedKey)
			collection = try values.decode(Collection.self, forKey: .collection)
			
			switch collection {
				case .repost:
					if let data = try? values.decode(Record.Repost.self, forKey: .record) {
						record = .repost(payload: data)
					} else {
						record = nil
					}
				case .follow:
					if let data = try? values.decode(Record.Follow.self, forKey: .record) {
						record = .follow(payload: data)
					} else {
						record = nil
					}
				case .like:
					if let data = try? values.decode(Record.Like.self, forKey: .record) {
						record = .like(payload: data)
					} else {
						record = nil
					}
				case .listItem:
					if let data = try? values.decode(Record.ListItem.self, forKey: .record) {
						record = .listItem(payload: data)
					} else {
						record = nil
					}
				case .block:
					if let data = try? values.decode(Record.Block.self, forKey: .record) {
						record = .block(payload: data)
					} else {
						record = nil
					}
				case .profile:
					if let data = try? values.decode(Record.Profile.self, forKey: .record) {
						record = .profile(payload: data)
					} else {
						record = nil
					}
				case .post:
					if let data = try? values.decode(Record.Post.self, forKey: .record) {
						record = .post(payload: data)
					} else {
						record = nil
					}
			}
		}
	}
	
	public enum Operation: String, Codable, Sendable {
		case create
		case update
		case delete
	}
}
