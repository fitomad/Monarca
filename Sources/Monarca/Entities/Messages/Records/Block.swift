//
//  Block.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//


import Foundation

extension Record {
	public struct Block: Codable, Sendable {
		public let createdAt: Date
		public let subjectIdentfier: String
		
		private enum CodingKeys: String, CodingKey {
			case createdAt
			case subjectIdentfier = "subject"
		}
	}
}