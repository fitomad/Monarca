//
//  Like.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension Record {
	public struct Like: Codable, Sendable {
		public let createdAt: Date
		public let subject: Record.LinkedIdentifier
		
		private enum CodingKeys: String, CodingKey {
			case createdAt
			case subject
		}
	}
}

