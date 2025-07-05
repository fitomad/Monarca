//
//  Collection.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

@available(*, deprecated, renamed: "BskyCollection", message: "This enumeration will be removed in future release. Use `BskyCollection` instead.")
public typealias Collection = BskyCollection

public enum BskyCollection: String, Codable, Sendable {
	case repost = "app.bsky.feed.repost"
	case like = "app.bsky.feed.like"
	case follow = "app.bsky.graph.follow"
	case listItem = "app.bsky.graph.listitem"
	case profile = "app.bsky.actor.profile"
	case block = "app.bsky.graph.block"
	case post = "app.bsky.feed.post"
	case starterPack = "app.bsky.graph.starterpack"
	case threadGate = "app.bsky.feed.threadgate"
	case postGate = "app.bsky.feed.postgate"
}

extension BskyCollection: CustomStringConvertible {
	public var description: String {
		rawValue
	}
}
