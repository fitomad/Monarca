//
//  AlphaTeal.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 11/12/25.
//

import Foundation

extension Record {
	public struct AlphaTeal: Codable, Sendable {
		public let expiredAt: Date
		public let time: Date
		public let item: Record.AlphaTeal.Item
		
		private enum CodingKeys: String, CodingKey {
			case expiredAt = "expiry"
			case time
			case item
		}
	}
}

extension Record.AlphaTeal {
	public struct Item: Codable, Sendable {
		public let artists: [String]
		public let trackName: String
		
		private enum CodingKeys: String, CodingKey {
			case artists
			case trackName
		}
	}
}
