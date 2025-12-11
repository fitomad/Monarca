//
//  NotificationDeclaration.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 11/12/25.
//

import Foundation

extension Record {
	public enum Notification {
		public struct Declaration: Codable, Sendable {
			public let allowSubscriptions: Record.Notification.Declaration.SubscriptionKind
			
			private enum CodingKeys: String, CodingKey {
				case allowSubscriptions = "allow_subscriptions"
			}
		}
	}
}

extension Record.Notification.Declaration {
	public enum SubscriptionKind: String, Codable, Sendable {
		case followers
		case mutuals
		case none
	}
}
