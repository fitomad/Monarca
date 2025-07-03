//
//  Commit.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension BskyMessage {
	public struct Commit: Codable, Sendable {
		public let did: String
		public let createdAt: Int
		public let kind: String
		public let payload: BskyMessage.Commit.Payload
		
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
		public let cid: String?
		public let operation: BskyMessage.Commit.Operation
		public let collection: Collection
		public let relatedKey: String
		public let record: Record?
		
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
			
			var decodedRecord: Record? = nil
			
			do {
				collection = try values.decode(Collection.self, forKey: .collection)
				
				switch collection {
					case .repost:
						if let data = try? values.decode(Record.Repost.self, forKey: .record) {
							decodedRecord = .repost(payload: data)
						}
					case .follow:
						if let data = try? values.decode(Record.Follow.self, forKey: .record) {
							decodedRecord = .follow(payload: data)
						}
					case .like:
						if let data = try? values.decode(Record.Like.self, forKey: .record) {
							decodedRecord = .like(payload: data)
						}
					case .listItem:
						if let data = try? values.decode(Record.ListItem.self, forKey: .record) {
							decodedRecord = .listItem(payload: data)
						}
					case .block:
						if let data = try? values.decode(Record.Block.self, forKey: .record) {
							decodedRecord = .block(payload: data)
						}
					case .profile:
						if let data = try? values.decode(Record.Profile.self, forKey: .record) {
							decodedRecord = .profile(payload: data)
						}
					case .post:
						if let data = try? values.decode(Record.Post.self, forKey: .record) {
							decodedRecord = .post(payload: data)
						}
					case .starterPack:
						if let data = try? values.decode(Record.StarterPack.self, forKey: .record) {
							decodedRecord = .starterPack(payload: data)
						}
				}
			} catch {
				throw BskyMessageManagerError.nonValidMessage
			}
			
			self.record = decodedRecord
		}
	}
	
	public enum Operation: String, Codable, Sendable {
		case create
		case update
		case delete
	}
}
