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
	
	func mapToWebSocketBootstrap(from url: URL) -> (host: String, port: Int, path: String)? {
		let uri = url.absoluteString
		
		let urlWithoutProtocol: String
		let defaultPort: Int
		
		if uri.hasPrefix("wss://") {
			urlWithoutProtocol = String(uri.dropFirst(6))
			defaultPort = 443
		} else if uri.hasPrefix("ws://") {
			urlWithoutProtocol = String(uri.dropFirst(5))
			defaultPort = 80
		} else {
			return nil
		}
		
		let components = urlWithoutProtocol.split(separator: "/", maxSplits: 1)
		let hostAndPort = String(components[0])
		let path = components.count > 1 ? "/" + String(components[1]) : "/"
		
		let hostComponents = hostAndPort.split(separator: ":")
		let host = String(hostComponents[0])
		let port = hostComponents.count > 1 ? Int(String(hostComponents[1])) ?? defaultPort : defaultPort
		
		return (host: host, port: port, path: path)
	}
}
