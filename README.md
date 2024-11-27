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
	// 🦋 Monarca framework
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

Monarca use a [Builder pattern] to configure and create the Jetstream connection 

```swift
let bskyFirehoseClient = try await DefaultFirehoseClientBuilder()
	.withHost(.usaEast1)
	.withCollections([ "a", "b", "c" ])
	.withDecentralizedIdentifiers(Constants.customIdentifierList)
	.withCompressionEnabled(false)
	.withHelloExecution(false)
	.withMaximumMessageSize(.kilobytes(value: 2048))
	.withPlayback(.seconds(5))
	.build()
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

[@fitomad.bsky.social](https://bsky.app/profile/fitomad.bsky.social)
[LinkedIn]()


