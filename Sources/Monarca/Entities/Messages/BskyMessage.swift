//
//  BskyMessage.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public enum BskyMessage: Sendable {
    case identity(payload: BskyMessage.Identity)
	case commit(payload: BskyMessage.Commit)
	case account(payload: BskyMessage.Account)
	case unknown(message: Data)
}
