//
//  BskyMessage.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public enum BskyMessage: Sendable {
    case identity(message: BskyMessage.Identity)
    case commit
    case account
}
