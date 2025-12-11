//
//  EmbedViewExternal.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 11/12/25.
//

import Foundation

extension Record {
	public struct EmbedViewExternal: Codable, Sendable {
		public let description: String
		public let title: String
		public let url: URL
		public let thumbnail: Record.Image
		
		private enum CodingKeys: String, CodingKey {
			case description
			case title
			case url = "uri"
			case thumbnail = "thumb"
		}
	}
}
