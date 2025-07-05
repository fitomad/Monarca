//
//  BskyMessageManager.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public protocol BskyMessageManager: Sendable {
	mutating func addMessageHandlerFilters(_ filters: [any BskyMessageHandler])
	func processMessage(content data: Data) async throws -> BskyMessage
    func processMessage(string value: String) async throws -> BskyMessage
}
