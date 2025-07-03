//
//  BskyFirehoseSettings.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public struct BskyFirehoseSettings: Sendable {
    public internal(set) var host: FireshoseHost?
	public internal(set) var collections: [String]?
	public internal(set) var decentralizedIdentifiers: [String]?
	public internal(set) var maximumMessageSize: MessageSize?
	public internal(set) var playback: Playback?
	public internal(set) var isCompressionEnabled: Bool?
	public internal(set) var isHelloRequired: Bool?
	public internal(set) var messageManager: (any BskyMessageManager)?
	public internal(set) var dedicatedThreads = 2
	
	mutating func set(host: FireshoseHost) {
		self.host = host
	}
	
	mutating func set(collections: [String]) {
		self.collections = collections
	}
	
	mutating func set(decentralizedIdentifiers: [String]) {
		self.decentralizedIdentifiers = decentralizedIdentifiers
	}
	
	mutating func set(maximumMessageSize: MessageSize) {
		self.maximumMessageSize = maximumMessageSize
	}
	
	mutating func set(playback: Playback) {
		self.playback = playback
	}
	
	mutating func set(isCompressionEnabled: Bool) {
		self.isCompressionEnabled = isCompressionEnabled
	}
	
	mutating func set(isHelloRequired: Bool) {
		self.isHelloRequired = isHelloRequired
	}
	
	mutating func set(messageManager: some BskyMessageManager) {
		self.messageManager = messageManager
	}
	
	mutating func set(dedicatedThreads: Int) {
		self.dedicatedThreads = dedicatedThreads
	}
	
	mutating func reset() async {
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
			var settings = Self.init()
			settings.set(host: .usaWest1)
			
			return settings
		}
    }
    
    public static var defaultEastCoast: Self {
		get async {
			var settings = Self.init()
			settings.set(host: .usaEast1)
			
			return settings
		}
	}
}

extension BskyFirehoseSettings: @preconcurrency CustomStringConvertible {
	public var description: String {
		var settingsContent = [String]()
		
		if let host {
			settingsContent.append("Host: \(host.endpoint)")
		}
		
		if let collections {
			settingsContent.append("Collections: \(collections.joined(separator: ", "))")
		}
		
		if let decentralizedIdentifiers {
			settingsContent.append("Decentralized IDs: \(decentralizedIdentifiers.joined(separator: ", "))")
		}
		
		if let maximumMessageSize {
			settingsContent.append("Maximum Message Size: \(maximumMessageSize.description)")
		}
		
		if let playback {
			settingsContent.append("Playback: \(playback.description)")
		}
		
		if let isCompressionEnabled {
			settingsContent.append("Compression enabled: \(isCompressionEnabled)")
		}
		
		if let isHelloRequired {
			settingsContent.append("Hello command: \(isHelloRequired)")
		}
		
		settingsContent.append("Dedicated threads: \(dedicatedThreads)")
		
		if settingsContent.isEmpty {
			return "⚠️ No settings provided."
		}
		
		
		return settingsContent.joined(separator: "\n")
	}
}
