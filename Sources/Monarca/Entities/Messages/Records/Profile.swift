//
//  Profile.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension Record {
	public struct Profile: Codable, Sendable {
		public let createdAt: Date
		public let description: String
		public let displayName: String
		public let pinnedPost: Record.LinkedIdentifier?
		public let avatar: Record.Image?
		public let banner: Record.Image?
		
		private enum CodingKeys: String, CodingKey {
			case createdAt
			case description
			case displayName
			case pinnedPost
			case avatar
			case banner
		}
	}
}
