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
}
