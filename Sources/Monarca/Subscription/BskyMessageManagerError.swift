//
//  BskyMessageManagerError.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

enum BskyMessageManagerError: Error {
    case nonValidMessage
    case unprocessable(message: Data)
    case unavailableHandlers
}
