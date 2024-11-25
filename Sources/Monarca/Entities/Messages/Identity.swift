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
            let did: String
            let userHandle: String
            let sequence: Int
            let createdAt: Date 
            
            private enum CodingKeys: String, CodingKey {
                case did
                case userHandle = "handle"
                case sequence = "seq"
                case createdAt = "time"
            }
        }
        
        let did: String
        let createdAt: Int    
        let kind: String
        let payload: BskyMessage.Identity.Payload 
        
        private enum CodingKeys: String, CodingKey {
            case did
            case createdAt = "time_us"
            case kind
            case payload = "identity"
        }
    }
}
