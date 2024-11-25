//
//  Commit.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension BskyMessage {
	public struct Commit: Codable, Sendable {
		public struct Payload: Codable, Sendable {
			let cid: String
			let operation: BskyMessage.Commit.Operation
			let collection: String
		}
		
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
	public enum Operation: Codable, Sendable {
		case create
		case update
		case delete
	}
}
