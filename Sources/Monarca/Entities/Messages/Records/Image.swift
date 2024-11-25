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
		public let location: Record.Reference
		
		private enum CodingKeys: String, CodingKey {
			case mimeType
			case size
			case location = "ref"
		}
	}
}
