//
//  PostGate.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 5/7/25.
//

import Foundation

extension Record {
	public struct PostGate: Codable, Sendable {
		public let createdAt: Date
		public let postDid: String
		public let embeddingRules: [Record.PostGate.Rule]
	}
}

extension Record.PostGate {
	public struct Rule: Codable, Sendable {
		public let type: String
		
		private enum CodingKeys: String, CodingKey {
			case type = "$type"
		}
	}
}
