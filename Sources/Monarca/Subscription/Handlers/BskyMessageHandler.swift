//
//  BskyMessageHandler.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public protocol BskyMessageHandler {
    var nextHandler: (any BskyMessageHandler)? { get set }
    
    func processMessage(content data: Data, using: JSONDecoder) throws -> BskyMessage
}
