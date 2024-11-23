//
//  BskyMessageManager.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public protocol BskyMessageManager {
	func processMessage(content data: Data) throws -> BskyMessage
    func processMessage(string value: String) throws -> BskyMessage
}
