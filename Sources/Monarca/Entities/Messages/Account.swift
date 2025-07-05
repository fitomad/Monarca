//
//  Account.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension BskyMessage {
	public struct Account: Codable, Sendable {
		public struct Payload: Codable, Sendable {
			public let isActive: Bool
			public let did: String
			public let sequence: Int
			public let createdAt: Date
			
			private enum CodingKeys: String, CodingKey {
				case isActive = "active"
				case did
				case sequence = "seq"
				case createdAt = "time"
			}
		}
		
		public let did: String
		public let createdAt: Int
		public let kind: String
		public let payload: BskyMessage.Account.Payload
		
		private enum CodingKeys: String, CodingKey {
			case did
			case createdAt = "time_us"
			case kind
			case payload = "account"
		}
	}
}
