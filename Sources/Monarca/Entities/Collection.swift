//
//  Collection.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

public enum Collection: String, Codable, Sendable {
	case repost = "app.bsky.feed.repost"
	case like = "app.bsky.feed.like"
	case follow = "app.bsky.graph.follow"
	case listItem = "app.bsky.graph.listitem"
	case profile = "app.bsky.actor.profile"
	case block = "app.bsky.graph.block"
	case post = "app.bsky.feed.post"
	case starterPack = "app.bsky.graph.starterpack"
}
