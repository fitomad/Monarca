//
//  IdentityMessageHandler.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

actor IdentityMessageHandler: Sendable {
	private(set) var nextHandler: (any BskyMessageHandler)?
    
    init(nextHandler: (any BskyMessageHandler)? = nil) {
        self.nextHandler = nextHandler
    }
}

extension IdentityMessageHandler: BskyMessageHandler {
	func setNextHandler(_ handler: any BskyMessageHandler) async {
		self.nextHandler = handler
	}
	
    func processMessage(content data: Data, using decoder: JSONDecoder) async throws -> BskyMessage {
        do {
            let identityMessage = try decoder.decode(BskyMessage.Identity.self, from: data)
            print("✅ \(identityMessage)")
            return .identity(message: identityMessage)
        } catch {
            guard let nextHandler else {
                throw BskyMessageManagerError.unprocessable(message: data)
            }
            
            return try await nextHandler.processMessage(content: data, using: decoder)
        }
        
    }
}
