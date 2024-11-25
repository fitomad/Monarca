//
//  Reference.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension Record {
	public struct Reference: Codable, Sendable {
		public let atProtocolLink: String
		
		private enum CodingKeys: String, CodingKey {
			case atProtocolLink = "$link"
		}
	}
}
