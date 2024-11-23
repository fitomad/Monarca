//
//  IdentityMessageHandler.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

final class IdentityMessageHandler {
    var nextHandler: (any BskyMessageHandler)?
    
    init(nextHandler: (any BskyMessageHandler)? = nil) {
        self.nextHandler = nextHandler
    }
}

extension IdentityMessageHandler: BskyMessageHandler {
    func processMessage(content data: Data, using decoder: JSONDecoder) throws -> BskyMessage {
        do {
            let identityMessage = try decoder.decode(BskyMessage.Identity.self, from: data)
            print("✅ \(identityMessage)")
            return .identity(message: identityMessage)
        } catch {
            guard let nextHandler else {
                throw BskyMessageManagerError.unprocessable(message: data)
            }
            
            return try nextHandler.processMessage(content: data, using: decoder)
        }
        
    }
}
