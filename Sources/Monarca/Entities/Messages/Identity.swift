//
//  Identity.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

extension BskyMessage {
    public struct Identity: Codable, Sendable {
        public struct Payload: Codable, Sendable {
            public let did: String
            public let userHandle: String
			public let sequence: Int
			public let createdAt: Date
            
            private enum CodingKeys: String, CodingKey {
                case did
                case userHandle = "handle"
                case sequence = "seq"
                case createdAt = "time"
            }
        }
        
		public let did: String
		public let createdAt: Int
		public let kind: String
		public let payload: BskyMessage.Identity.Payload 
        
        private enum CodingKeys: String, CodingKey {
            case did
            case createdAt = "time_us"
            case kind
            case payload = "identity"
        }
    }
}
