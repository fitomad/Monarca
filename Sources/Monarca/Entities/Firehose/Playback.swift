//
//  Playback.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public enum Playback: Sendable {
    case now
    case milliseconds(_ value: Int)
    case seconds(_ value: Int)
    case minutes(_ value: Int)
    
    var timeValue: Int {
		let now = Date()
		
        switch self {
			case .now:
				return Int((now + 1_000).timeIntervalSince1970)
			case .milliseconds(let value):
				return Int((now - TimeInterval((value / 1_000))).timeIntervalSince1970)
			case .seconds(let value):
				return Int((now - TimeInterval(value)).timeIntervalSince1970)
			case .minutes(let value):
				return Int((now - TimeInterval((60 * value))).timeIntervalSince1970)
        }
    }
}

extension Playback: Equatable {
	public static func ==(lhs: Playback, rhs: Int) -> Bool {
		lhs.timeValue == rhs
	}
}

extension Playback: CustomStringConvertible {
	public var description: String {
		switch self {
			case .now:
				return "Right now (no playback)."
			case .milliseconds(let value):
				return "\(value)ms"
			case .seconds(let value):
				return "\(value)s"
			case .minutes(let value):
				return "\(value)m"
		}
	}
}
