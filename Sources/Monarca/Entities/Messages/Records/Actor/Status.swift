//
//  Status.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 11/12/25.
//

import Foundation

extension Record.Actor {
	public struct Status: Codable, Sendable {
		public let createdAt: Date
		public let durationInMinutes: Int
		public let embedContent: Record.Actor.Status.Embed
		
		private enum CodingKeys: String, CodingKey {
			case createdAt = "createdAt"
			case durationInMinutes = "durationMinutes"
			case embedContent = "embed"
		}
	}
}

extension Record.Actor.Status {
	public struct Embed: Codable, Sendable {
		public let external: Record.EmbedViewExternal
	}
}
