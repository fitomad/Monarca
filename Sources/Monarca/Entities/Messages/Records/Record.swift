//
//  RepostRecord.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation

public enum Record: Codable, Sendable {
	case repost(payload: Record.Repost)
	case follow(payload: Record.Follow)
	case like(payload: Record.Like)
	case listItem(payload: Record.ListItem)
	case block(payload: Record.Block)
	case profile(payload: Record.Profile)
	case post(payload: Record.Post)
	case starterPack(payload: Record.StarterPack)
}


