//
//  BskyFirehoseError.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public enum BskyFirehoseError: Error {
	case invalidFirehoseURL
	case invalidConnectionParameters
	case invalidData
	case messageManagerNotAvailable
	case invalidMessage(content: BskyFirehoseError.Content)
}

extension BskyFirehoseError {
	public enum Content: Sendable {
		case string(_ value: String)
		case data(_ value: Data)
	}
}

extension BskyFirehoseError: Equatable {
	public static func == (lhs: BskyFirehoseError, rhs: BskyFirehoseError) -> Bool {
		switch (lhs, rhs) {
			case (.invalidFirehoseURL, .invalidFirehoseURL): return true
			case (.invalidConnectionParameters, .invalidConnectionParameters): return true
			case (.invalidData, .invalidData): return true
			case (.messageManagerNotAvailable, .messageManagerNotAvailable): return true
			case (.invalidMessage, .invalidMessage): return true
			default: return false
		}
	}
}
