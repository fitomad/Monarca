//
//  BskyFirehoseSettings.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public actor BskyFirehoseSettings: Sendable {
    public internal(set) var host: FireshoseHost?
	public internal(set) var collections: [String]?
	public internal(set) var decentralizedIdentifiers: [String]?
	public internal(set) var maximumMessageSize: MessageSize?
	public internal(set) var playback: Playback?
	public internal(set) var isCompressionEnabled: Bool?
	public internal(set) var isHelloRequired: Bool?
	public internal(set) var messageManager: (any BskyMessageManager)?
	
	func set(host: FireshoseHost) {
		self.host = host
	}
	
	func set(collections: [String]) {
		self.collections = collections
	}
	
	func set(decentralizedIdentifiers: [String]) {
		self.decentralizedIdentifiers = decentralizedIdentifiers
	}
	
	func set(maximumMessageSize: MessageSize) {
		self.maximumMessageSize = maximumMessageSize
	}
	
	func set(playback: Playback) {
		self.playback = playback
	}
	
	func set(isCompressionEnabled: Bool) {
		self.isCompressionEnabled = isCompressionEnabled
	}
	
	func set(isHelloRequired: Bool) {
		self.isHelloRequired = isHelloRequired
	}
	
	func set(messageManager: some BskyMessageManager) {
		self.messageManager = messageManager
	}
	
	func reset() async {
		host = nil
		collections = nil
		decentralizedIdentifiers = nil
		maximumMessageSize = nil
		playback = nil
		isCompressionEnabled = nil
		isHelloRequired = nil
		messageManager = nil
	}
}

extension BskyFirehoseSettings {
	public static var defaultWestCoast: Self {
		get async {
			let settings = Self.init()
			await settings.set(host: .usaWest1)
			
			return settings
		}
    }
    
    public static var defaultEastCoast: Self {
		get async {
			let settings = Self.init()
			await settings.set(host: .usaEast1)
			
			return settings
		}
	}
}
