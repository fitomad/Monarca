//
//  AccountMessageHandler.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

actor AccountMessageHandler: Sendable {
	private(set) var nextHandler: (any BskyMessageHandler)?
}

extension AccountMessageHandler: BskyMessageHandler {
	func setNextHandler(_ handler: any BskyMessageHandler) async {
		self.nextHandler = handler
	}
	
	func processMessage(content data: Data, using decoder: JSONDecoder) async throws -> BskyMessage {
		do {
			let accountMessage = try decoder.decode(BskyMessage.Account.self, from: data)
			print("✅ \(accountMessage)")
			return .account(payload: accountMessage)
		} catch {
			guard let nextHandler else {
				throw BskyMessageManagerError.unprocessable(message: data)
			}
			
			return try await nextHandler.processMessage(content: data, using: decoder)
		}
		
	}
}
