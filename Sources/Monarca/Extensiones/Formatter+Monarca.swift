//
//  Formatter+Monarca.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

extension Formatter {
   static var customISO8601DateFormatter: ISO8601DateFormatter {
	  let formatter = ISO8601DateFormatter()
	  formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
	  return formatter
   }
}
