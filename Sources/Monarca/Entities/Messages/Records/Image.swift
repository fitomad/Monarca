//
//  Image.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension Record {
	public struct Image: Codable, Sendable {
		public let mimeType: String
		public let size: Int
		public let bskyURL: String
		
		private enum CodingKeys: String, CodingKey {
			case mimeType
			case size
			case bskyURL = "ref"
		}
		
		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			
			mimeType = try values.decode(String.self, forKey: .mimeType)
			size = try values.decode(Int.self, forKey: .size)
			
			let reference = try values.decode(Record.Reference.self, forKey: .bskyURL)
			bskyURL = reference.atProtocolLink
		}
	}
}
