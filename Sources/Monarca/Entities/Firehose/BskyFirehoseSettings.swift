//
//  BskyFirehoseSettings.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public struct BskyFirehoseSettings {
    public internal(set) var host: FireshoseHost?
	public internal(set) var collections: [String]?
	public internal(set) var decentralizedIdentifiers: [String]?
	public internal(set) var maximumMessageSize: MessageSize?
	public internal(set) var playback: Playback?
	public internal(set) var isCompressionEnabled: Bool?
	public internal(set) var isHelloRequired: Bool?
}

extension BskyFirehoseSettings {
    public static var defaultWestCoast: Self {
        var settings = Self.init()
        settings.host = .usaWest1
        
        return settings
    }
    
    public static var defaultEastCoast: Self {
		var settings = Self.init()
		settings.host = .usaEast1
            
		return settings
	}
}
