//
//  AllMessagesManager.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

actor AllMessagesManager: BskyMessageManager {
    private let handlersChain: [any BskyMessageHandler]
    private let jsonDecoder = JSONDecoder()
    
    init() async {
        handlersChain = [
            IdentityMessageHandler(),
			AccountMessageHandler()
        ]
        
        jsonDecoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
        
        try? await buildHandlersChain()
    }
    
    private func buildHandlersChain() async throws {
        guard handlersChain.isEmpty == false else {
            throw BskyMessageManagerError.unavailableHandlers
        }
        
        for index in 0 ..< (handlersChain.count - 1) {
            await handlersChain[index].setNextHandler(handlersChain[index + 1])
        }
    }
    
    func processMessage(content data: Data) async throws -> BskyMessage {
		guard let firstHandler = handlersChain.first else {
			throw BskyMessageManagerError.unavailableHandlers
        }
        
        do {
			return try await firstHandler.processMessage(content: data, using: jsonDecoder)
        } catch {
            throw BskyMessageManagerError.unprocessable(message: data)
        }
    }

	func processMessage(string value: String) async throws -> BskyMessage {
		guard let data = value.data(using: .utf8) else {
			throw BskyMessageManagerError.nonValidMessage
		}
		
		return try await processMessage(content: data)
	}
}
