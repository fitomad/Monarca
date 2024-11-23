//
//  FireshoseHost.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public enum FireshoseHost: Sendable {
    case usaEast1
    case usaEast2
    case usaWest1
    case usaWest2
    case custom(server: String)
    
    var endpoint: String {
        switch self {
        case .usaEast1:
            return "wss://jetstream1.us-east.bsky.network/subscribe"
        case .usaEast2:
            return "wss://jetstream2.us-east.bsky.network/subscribe"
        case .usaWest1:
            return "wss://jetstream1.us-west.bsky.network/subscribe"
        case .usaWest2:
            return "wss://jetstream2.us-west.bsky.network/subscribe"
        case .custom(let server):
            return server
        }
    }
}
