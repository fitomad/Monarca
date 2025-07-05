//
//  ThreadGate.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 5/7/25.
//

import Foundation

extension Record {
	public struct ThreadGate: Codable, Sendable {
		public let createdAt: Date
		public let postDid: String
		public let allow: [Record.ThreadGate.AllowType]
		
		private enum CodingKeys: String, CodingKey {
			case createdAt
			case postDid = "post"
			case allow
		}
	}
}

extension Record.ThreadGate {
	public struct AllowType: Codable, Sendable {
		public let type: String
		
		private enum CodingKeys: String, CodingKey {
			case type = "$type"
		}
	}
}
