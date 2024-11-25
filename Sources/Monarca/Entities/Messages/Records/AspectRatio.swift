//
//  AspectRatio.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

extension Record {
	public struct AspectRatio: Codable, Sendable {
		public let height: Int
		public let width: Int
		
		private enum CodingKeys: String, CodingKey {
			case height
			case width
		}
	}
}
