//
//  MessageSize.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

public enum MessageSize: Sendable {
    case unlimited
    case bytes(value: Int)
    case kilobytes(value: Int)
    case megabytes(value: Int)
    
    var value: Int {
        switch self {
        case .unlimited:
            return 0
        case .bytes(let value):
            return value
        case .kilobytes(let value):
            return 1024 * value
        case .megabytes(let value):
            return 1024 * 1024 * value
        }
    }
}

extension MessageSize: Equatable {
	public static func ==(lhs: Self, rhs: Int) -> Bool {
		lhs.value == rhs
	}
}

extension MessageSize: CustomStringConvertible {
	public var description: String {
		switch self {
			case .unlimited:
				return "Unlimited message size"
			case .bytes(let value):
				return "\(value) bytes"
			case .kilobytes(let value):
				return "\(value) KB"
			case .megabytes(let value):
				return "\(value) MB"
		}
	}
}
