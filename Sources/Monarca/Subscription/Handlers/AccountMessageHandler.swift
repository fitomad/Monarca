//
//  AccountMessageHandler.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

struct AccountMessageHandler {
	private(set) var nextHandler: (any BskyMessageHandler)?
}

extension AccountMessageHandler: BskyMessageHandler {
	mutating func setNextHandler(_ handler: any BskyMessageHandler) {
		self.nextHandler = handler
	}
	
	mutating func processMessage(content data: Data, using decoder: JSONDecoder) async throws -> BskyMessage {
		do {
			let accountMessage = try decoder.decode(BskyMessage.Account.self, from: data)
			return .account(payload: accountMessage)
		} catch {
			guard var nextHandler else {
				throw BskyMessageManagerError.unprocessable(message: data)
			}
			
			return try await nextHandler.processMessage(content: data, using: decoder)
		}
		
	}
}
