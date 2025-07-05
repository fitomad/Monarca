# Monarca 

Monarca is a Swift project designed to consume the BlueSky Firehose using the [Jetstream](https://docs.bsky.app/blog/jetstream) service. It enables real-time data ingestion and processing for applications built on the BlueSky protocol.

## Features

- **Real-time Data Streaming**: Seamlessly consumes BlueSky Firehose streams via Jetstream.
- **Swift Integration**: Built with Swift, ensuring a fast and native experience.
- **Swift 6 Concurrency**: Adopts the new Swift concurrency model.
- **Lightweight and Efficient**: Optimized for performance and low latency.
- **Supported collection**: Custom types for the following `Commit` type messages 
	- `app.bsky.feed.like`
	- `app.bsky.graph.follow`
	- `app.bsky.graph.listitem`
	- `app.bsky.actor.profile`
	- `app.bsky.graph.block`
	- `app.bsky.feed.post`
	- `app.bsky.graph.starterpack`

## Requirements

- Swift 6.0 or later
- macOS 13.0+ || iOS 13+
- Internet connection to access the BlueSky Jetstream service

## Installation

Monarca is distributed using Swift Package Manager so you can include easily in your Swift Packages or Xcode projects.

## Adding package dependency

Include the following line in the `dependencies` section of your *Package.swift* file

```swift
...
dependencies: [
	// 🦋 Monarca
	.package(url: "https://github.com/fitomad/monarca.git", from: "0.2.0")
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

- Jetstream server - `connecto(to:)`: **Mandatory**. Select one of the four general available Jetstream servers or connect to a custon server using the `.custom(server:)` case, where `server` is a `String` that contains the URL to your server.
- `wantedCollections` - `forCollections`: A `String` array with the collection's NSID.
- `wantedDids` - `withDecentralizedIdentifiers`: A `String` array with the repo DIDs to filter which records you receive on your stream.
- `compress` - `compressionEnabled`: A boolean value to enable `zstd` compression. Default `false`
- `requireHello` - `withHelloExecution`: A boolean value to replay/live-tail until the server recevies a `SubscriberOptionsUpdatePayload` over the socket in a *Subscriber Sourced Message*. Default `false`
- `maxMessageSizeBytes` - `maximumMessageSizeAllowed`: Filters by message size. You can set this size using the helper enumeration `MessageSize`
- `cursor` - `messagesPlayback(since:)`: A unix microseconds timestamp cursor to begin playback if you reconnect or connect to a new Jetstream server. You can set the value using the helper enumeration `Playback`

This connection reveices all Bluesky messages for all collection and DIDs from the `jetstream1` server located in the US east coast. No compression enabled, witho no `hello` command needed and with no message size limitation.

```swift
let bskyFirehoseClient = try await DefaultFirehoseClientBuilder()
	.connect(to: .usaEast1)
	.build()
```

This example connection uses all the settings available

```swift
let firehoseClient = try DefaultFirehoseClientBuilder()
	.connect(to: .usaEast1)
	.forCollections([ .post, .repost, .like ])
	.withDecentralizedIdentifiers(Constants.customIdentifierList)
	.compressionEnabled(false)
	.withHelloExecution(false)
	.maximumMessageSizeAllowed(.kilobytes(value: 2048))
	.messagesPlayback(since: .seconds(5))
	.dedicatedThreads(count: 8)
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

## Error management

You can capture and manage errors from the Jetstream connection using the `onErrorProcessingMessage(:_)` that receives a `BskyFirehoseError` error type.


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

In case you receive a *strange* message from Jetstream, you can inspect the whole websoccket response available in the `invalidMessage` error type, that has an `URLSessionWebSocketTask.Message` as associated type.

## Jetstream message parsing engine

Apart from the parameters specific to the Jetstream connection, you can set up your own message parsing engine. By default, Monarca provides its own parsing engine, so this step is not necessary, but it's left open in case your project has special requirements.

The only requirement is that your parsing engine implements the BskyMessageManager protocol, which will handle receiving messages from the WebSocket connected to Jetstream and return a BskyMessage type message.

```swift
struct MockMessageManager: BskyMessageManager {
	func processMessage(content data: Data) throws -> BskyMessage {
		// Do things with the message here
	}
	
	func processMessage(string value: String) throws -> BskyMessage {
		guard let data = value.data(using: .utf8) else {
			throw MyError.strangeMessage
		}
		
		return try await processMessage(content: data)
	}
}
```

Once you finish to develop the custom message manager component, use the `withMessageManager(_:)` function to set your custom component.

```swift
let bskyFirehoseClient = try await DefaultFirehoseClientBuilder()
	.connect(to: .usaEast1)
	.useCustomMessageManager(MockMessageManager)
	.build()
```

Now you are ready to receive new messages and process them using your custom manager.

## License

Monarca is licensed under the MIT License. See LICENSE for details.

## Acknowledgments

- [BlueSky developer](https://docs.bsky.app/docs/get-started)
- [Jetstream Documentation](https://docs.bsky.app/blog/jetstream)

## Version history

### 0.2.0

- Migrate from the `URLSessionWebSocketTask` to the [SwiftNIO](https://github.com/apple/swift-nio) based WebSocket connection using the [WebSocketKit](https://github.com/vapor/websocket-kit) framework
- Renaming some `BskyFirehoseClientBuilder` functions to bring a *Fluid* approach to the API. Old funcions are now marked as *deprecated* and will be removed in future versions.
- Work to adopt Swift 6 Concurrency model is still in progress.
- Now you can filter `app.bsky.feed.post` messages by hashtag or by content with the new functions availables in the `BskyFirehoseClientBuilder` implementation
	- `applyContentFilter(by:)` Process only those messages that contains 1 or N of the given hashtags
	- `applyHashtagFilter(by:)` Process only those messages that contains 1 or N of the given words
- Information about**video** in a *Post* message.

### 0.1.0

- Bluesky Firehose connection using Jetstreams.
- Custom types for the following messages
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

You can reach me here 👇

- [🦋 @fitomad.bsky.social](https://bsky.app/profile/fitomad.bsky.social)
- [LinkedIn](https://www.linkedin.com/in/adolfo-vera/)
