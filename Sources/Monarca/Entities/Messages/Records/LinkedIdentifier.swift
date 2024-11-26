//
//  LinkedIdentifier.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension Record {
	public struct LinkedIdentifier: Codable, Sendable {
		public let contentIdentifier: String
		public let bskyURL: String
		
		private enum CodingKeys: String, CodingKey {
			case contentIdentifier = "cid"
			case bskyURL = "uri"
		}
	}
}
