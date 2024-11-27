# Monarca 

Monarca is a Swift project designed to consume the BlueSky Firehose using the [Jetstream](https://docs.bsky.app/blog/jetstream) service. It enables real-time data ingestion and processing for applications built on the BlueSky protocol.

## Features

- **Real-time Data Streaming**: Seamlessly consumes BlueSky Firehose streams via Jetstream.
- **Swift Integration**: Built with Swift, ensuring a fast and native experience.
- **Swift 6 Concurrency**: Adopts the new Swift concurrency model.
- **Lightweight and Efficient**: Optimized for performance and low latency.
- **Supported collection`**: Custom types for the following `Commit` type messages 
	- `app.bsky.feed.like`
	- `app.bsky.graph.follow`
	- `app.bsky.graph.listitem`
	- `app.bsky.actor.profile`
	- `app.bsky.graph.block`
	- `app.bsky.feed.post`
	- `app.bsky.graph.starterpack`

## Requirements

- Swift 6.0 or later
- macOS 13.0+
- Internet connection to access the BlueSky Jetstream service

## Installation

Monarca is distributed using Swift Package Manager so you can include easily in your Swift Packages or Xcode projects.

## Adding package dependency

Include the following line in the `dependencies` section of your *Package.swift* file

```swift
...
dependencies: [
	// 🦋 Monarca
	.package(url: "https://github.com/fitomad/monarca.git", from: "1.0")
]
...
```

## Usage

1. Import Monarca into your Swift project:

```swift
import Monarca
```
2. Initialize the Firehose client:

Monarca use a [Builder pattern](https://refactoring.guru/design-patterns/builder) to configure and create the Jetstream connection. 

The builder is available through the `DefaultFirehoseClientBuilder` class. You can configure the following Jetstream connection with these builder functions.

- Jetstream server - `withHost`: **Mandatory**. Select one of the four general available Jetstream servers or connect to a custon server using the `.custom(server:)` case, where `server` is a `String` that contains the URL to your server.
- `wantedCollections` - `withCollections`: A `String` array with the collection's NSID.
- `wantedDids` - `withDecentralizedIdentifiers`: A `String` array with the repo DIDs to filter which records you receive on your stream.
- `compress` - `withCompression`: A boolean value to enable `zstd` compression. Default `false`
- `requireHello` - `withHelloExecution`: A boolean value to replay/live-tail until the server recevies a `SubscriberOptionsUpdatePayload` over the socket in a *Subscriber Sourced Message*. Default `false`
- `maxMessageSizeBytes` - `withMaximumMessageSize`: Filters by message size. You can set this size using the helper enumeration `MessageSize`
- `cursor` - `withPlayback`: A unix microseconds timestamp cursor to begin playback if you reconnect or connect to a new Jetstream server. You can set the value using the helper enumeration `Playback`

This connection reveices all Bluesky messages for all collection and DIDs from the `jetstream1` server located in the US east coast. No compression enabled, witho no `hello` command needed and with no message size limitation.

```swift
let bskyFirehoseClient = try await DefaultFirehoseClientBuilder()
	.withHost(.usaEast1)
	.build()
```

This example connection uses all the settings available

```swift
let bskyFirehoseClient = try await DefaultFirehoseClientBuilder()
	.withHost(.usaEast1)
	.withCollections([ "app.bsky.feed.post", "app.bsky.feed.like" ])
	.withDecentralizedIdentifiers([ "did:97531", "did:13579" ])
	.withCompressionEnabled(true)
	.withHelloExecution(true)
	.withMaximumMessageSize(.kilobytes(value: 2048))
	.withPlayback(.seconds(5))
	.build()
```

## Receiving messages

```swift
await bskyFirehoseClient.onMessageReceived { message in
	switch message {
		case .account(let payload):
			print("𝓐 Account")
		case .commit:
			
		case .identity(let message):
			
		case .unknown(let data):
	}
}
```

Error management

```swift
await firehoseClient.onErrorProcessingMessage { bskyFirehoseError in
	switch bskyFirehoseError {
		case invalidMessage(let websocketMessage):
			switch websocketMessage {
				case .data(let data):
					//
				case .string(let string):

				@unknown default:

			}
		case .invalidFirehoseURL:
			// The custom Jetstream URL is not valid
		case .invalidConnectionParameters:
			// The connection parameters are rejected by server
		case .invalidData:

		case .messageManagerNotAvailable:
			// There is no message manager component available
			// or the one you provide is not valid.
	}
}
```

## License

Monarca is licensed under the MIT License. See LICENSE for details.

## Acknowledgments

- [BlueSky developer](https://docs.bsky.app/docs/get-started)
- [Jetstream Documentation](https://docs.bsky.app/blog/jetstream)

## Version history

### 1.0

Bluesky Firehose connection using Jetstreams.

Custom types for the following messages

- Account
- Identity
- Commit
	- `app.bsky.feed.like`
	- `app.bsky.graph.follow`
	- `app.bsky.graph.listitem`
	- `app.bsky.actor.profile`
	- `app.bsky.graph.block`
	- `app.bsky.feed.post`
	- `app.bsky.graph.starterpack`


## Author

[🦋 @fitomad.bsky.social](https://bsky.app/profile/fitomad.bsky.social)
[LinkedIn](https://www.linkedin.com/in/adolfo-vera/)


