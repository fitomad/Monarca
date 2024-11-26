//
//  BskyMessageHandler.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public protocol BskyMessageHandler: Sendable {
    func setNextHandler(_ handler: any BskyMessageHandler) async
    func processMessage(content data: Data, using: JSONDecoder) async throws -> BskyMessage
}
