//
//  MockMessageManager.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 24/11/24.
//

import Foundation
@testable import Monarca

protocol TestableMessageManager {
	var filtersCount: Int { get }
}

struct MockMessageManager: BskyMessageManager {
	var mockFilters: [any BskyMessageHandler] = []
	
	mutating func addMessageHandlerFilters(_ filters: [any BskyMessageHandler]) {
		mockFilters.append(contentsOf: filters)
	}
	
	func processMessage(content data: Data) throws -> BskyMessage {
		throw BskyMessageManagerError.nonValidMessage
	}
	
	func processMessage(string value: String) throws -> BskyMessage {
		throw BskyMessageManagerError.nonValidMessage
	}
}

extension MockMessageManager: TestableMessageManager {
	var filtersCount: Int {
		return mockFilters.count
	}
}

extension AllMessagesManager: TestableMessageManager {
	var filtersCount: Int {
		self.handlersChain.count
	}
}
