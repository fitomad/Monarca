//
//  BskyFirehoseSettingsMapper.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 21/11/24.
//

import Foundation

struct BskyFirehoseSettingsMapper {
    func mapToURL(from settings: BskyFirehoseSettings) async throws(FirehoseMapperError) -> URL {
        guard let host = await settings.host,
              var urlComponents = URLComponents(string: host.endpoint)
        else 
        {
			throw .malformedParameterURL
        }
        
        var firehoseQueryItems = [URLQueryItem]()
        
        if let collections = await settings.collections {
            let filteredCollections = collections.map { URLQueryItem(name: "wantedCollections", value: $0) }
            firehoseQueryItems.append(contentsOf: filteredCollections)
        }
        
        if let identifiers = await settings.decentralizedIdentifiers {
            let filteredIdentifiers = identifiers.map { URLQueryItem(name: "wantedDids", value: $0) }
            firehoseQueryItems.append(contentsOf: filteredIdentifiers)
        }
        
        if let isCompressionEnabled = await settings.isCompressionEnabled {
            let filterCompression = URLQueryItem(name: "compress", value: String(isCompressionEnabled))
            firehoseQueryItems.append(filterCompression)
        }
        
        if let playback = await settings.playback {
            let filterPlayback = URLQueryItem(name: "cursor", value: "\(playback.timeValue)")
            firehoseQueryItems.append(filterPlayback)
        }
        
        if let messageSize = await settings.maximumMessageSize {
            let filteMessageSize = URLQueryItem(name: "maxMessageSizeBytes", value: "\(messageSize.value)")
            firehoseQueryItems.append(filteMessageSize)
        }
        
        if let isHelloRequired = await settings.isHelloRequired {
            let filterHelloRequired = URLQueryItem(name: "requireHello", value: String(isHelloRequired))
            firehoseQueryItems.append(filterHelloRequired)
        }
        
        if !firehoseQueryItems.isEmpty {
            urlComponents.queryItems = firehoseQueryItems
        }
        
        guard let jetstreamURL = urlComponents.url else {
			throw .malformedGeneratedURL
		}
        
        return jetstreamURL
    }
}
