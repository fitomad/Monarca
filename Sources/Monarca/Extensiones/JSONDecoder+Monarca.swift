//
//  JSONDecoder+Monarca.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
   static let iso8601WithFractionalSeconds = custom { decoder in
	  let dateString = try decoder.singleValueContainer().decode(String.self)
	  let customIsoFormatter = Formatter.customISO8601DateFormatter
	  if let date = customIsoFormatter.date(from: dateString) {
		 return date
	  }
	   
	  throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath,
															  debugDescription: "Invalid date"))
   }
}
