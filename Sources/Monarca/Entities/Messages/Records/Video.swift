//
//  Video.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 4/7/25.
//

extension Record {
	public struct Video: Codable, Sendable {
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
