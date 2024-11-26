//
//  MockMessageManager.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 24/11/24.
//

import Foundation
@testable import Monarca

struct MockMessageManager: BskyMessageManager {
	func processMessage(content data: Data) throws -> BskyMessage {
		throw BskyMessageManagerError.nonValidMessage
	}
	
	func processMessage(string value: String) throws -> BskyMessage {
		throw BskyMessageManagerError.nonValidMessage
	}
}
