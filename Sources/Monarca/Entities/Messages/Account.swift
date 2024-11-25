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
			let isActive: Bool
			let did: String
			let sequence: Int
			let createdAt: Date
			
			private enum CodingKeys: String, CodingKey {
				case isActive = "active"
				case did
				case sequence = "seq"
				case createdAt = "time"
			}
		}
		
		let did: String
		let createdAt: Int
		let kind: String
		let payload: BskyMessage.Account.Payload
		
		private enum CodingKeys: String, CodingKey {
			case did
			case createdAt = "time_us"
			case kind
			case payload = "account"
		}
	}
}
