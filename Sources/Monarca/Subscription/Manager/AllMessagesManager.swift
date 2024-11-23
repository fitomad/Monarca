//
//  AllMessagesManager.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

final class AllMessagesManager: BskyMessageManager {
    private var handlersChain: [any BskyMessageHandler]
    private let jsonDecoder = JSONDecoder()
    
    init() {
        handlersChain = [
            IdentityMessageHandler()
        ]
        
        jsonDecoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
        
        try? buildHandlersChain()
    }
    
    private func buildHandlersChain() throws {
        guard handlersChain.isEmpty == false else {
            throw BskyMessageManagerError.unavailableHandlers
        }
        
        for index in 0 ..< (handlersChain.count - 1) {
            handlersChain[index].nextHandler = handlersChain[index + 1]
        }
    }
    
    func processMessage(content data: Data) throws -> BskyMessage {
		guard let firstHandler = handlersChain.first else {
			throw BskyMessageManagerError.unavailableHandlers
        }
        
        do {
			let incomingMessage = try firstHandler.processMessage(content: data, using: jsonDecoder)
			return incomingMessage
        } catch {
            throw BskyMessageManagerError.unprocessable(message: data)
        }
    }

	func processMessage(string value: String) throws -> BskyMessage {
		guard let data = value.data(using: .utf8) else {
			throw BskyMessageManagerError.nonValidMessage
		}
		
		return try processMessage(content: data)
	}
}
