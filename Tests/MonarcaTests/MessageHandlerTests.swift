//
//  MessageHandlerTests.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Foundation
import Testing
@testable import Monarca

@Suite("Message handlers test")
struct MessageHandlerTests {
	var jsonDecoder: JSONDecoder {
		let jsonDecoder = JSONDecoder()
		jsonDecoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
		
		return jsonDecoder
	}
	
	@Test("Commit // Like", .tags(.messageHandler))
	func testCommitLikeDecoding() async throws {
		guard let data = MockMessages.commitLike.data(using: .utf8) else {
			throw MessageHandlerTestsError.invalidJSON
		}
		
		let handler = CommitMessageHandler()
		let message = try await handler.processMessage(content: data, using: jsonDecoder)
		
		if case let .commit(likeMessage) = message {
			#expect(likeMessage.did == "did:plc:eygmaihciaxprqvxpfvl6flk")
			#expect(likeMessage.payload.relatedKey == "3l3qo2vuowo2b")
			#expect(likeMessage.payload.record != nil)
			
			if case let .like(content) = likeMessage.payload.record! {
				#expect(content.subject.cid == "bafyreidc6sydkkbchcyg62v77wbhzvb2mvytlmsychqgwf2xojjtirmzj4")
			} else {
				throw MessageHandlerTestsError.contentNotAvailable
			}
		} else {
			throw MessageHandlerTestsError.contentNotAvailable
		}
	}
	
	@Test("Commit // Repost", .tags(.messageHandler))
	func testCommitRepostDecoding() async throws {
		guard let data = MockMessages.commitRepost.data(using: .utf8) else {
			throw MessageHandlerTestsError.invalidJSON
		}
		
		let handler = CommitMessageHandler()
		let message = try await handler.processMessage(content: data, using: jsonDecoder)
		
		if case let .commit(repostMessage) = message {
			#expect(repostMessage.did == "did:plc:xgsysfc6hrwpf5nna5fxmj5c")
			#expect(repostMessage.payload.relatedKey == "3lbrtimnp3z25")
			#expect(repostMessage.payload.record != nil)
			
			if case let .repost(content) = repostMessage.payload.record! {
				#expect(content.subject.cid == "bafyreig34fxgp2zg7q7xdffxlkhkmivs4nb4hs4xawjsvmnwuczdhzll5e")
			} else {
				throw MessageHandlerTestsError.contentNotAvailable
			}
		} else {
			throw MessageHandlerTestsError.contentNotAvailable
		}
	}
	
	@Test("Commit // Follow", .tags(.messageHandler))
	func testCommitFollowDecoding() async throws {
		guard let data = MockMessages.commitFollow.data(using: .utf8) else {
			throw MessageHandlerTestsError.invalidJSON
		}
		
		let handler = CommitMessageHandler()
		let message = try await handler.processMessage(content: data, using: jsonDecoder)
		
		if case let .commit(followMessage) = message {
			#expect(followMessage.did == "did:plc:5z3jsxbvy6k3arqa2csj66li")
			#expect(followMessage.payload.relatedKey == "3lbrtimldmi23")
			#expect(followMessage.payload.record != nil)
			
			if case let .follow(content) = followMessage.payload.record! {
				#expect(content.subjectIdentfier == "did:plc:vqdfh7svffgjkes4iz54iyz7")
			} else {
				throw MessageHandlerTestsError.contentNotAvailable
			}
		} else {
			throw MessageHandlerTestsError.contentNotAvailable
		}
	}
	
	@Test("Commit // ListItem", .tags(.messageHandler))
	func testCommitListItemDecoding() async throws {
		guard let data = MockMessages.commitListItem.data(using: .utf8) else {
			throw MessageHandlerTestsError.invalidJSON
		}
		
		let handler = CommitMessageHandler()
		let message = try await handler.processMessage(content: data, using: jsonDecoder)
		
		if case let .commit(listItemMessage) = message {
			#expect(listItemMessage.did == "did:plc:eilpxwyvy34ecczfgi74qgb2")
			#expect(listItemMessage.payload.relatedKey == "3lbrtime62t2h")
			#expect(listItemMessage.payload.record != nil)
			
			if case let .listItem(content) = listItemMessage.payload.record! {
				#expect(content.subjectIdentfier == "did:plc:bfqd3yciudy4gvho356ajupt")
			} else {
				throw MessageHandlerTestsError.contentNotAvailable
			}
		} else {
			throw MessageHandlerTestsError.contentNotAvailable
		}
	}
	
	@Test("Commit // Block", .tags(.messageHandler))
	func testCommitBlockDecoding() async throws {
		guard let data = MockMessages.commitBlock.data(using: .utf8) else {
			throw MessageHandlerTestsError.invalidJSON
		}
		
		let handler = CommitMessageHandler()
		let message = try await handler.processMessage(content: data, using: jsonDecoder)
		
		if case let .commit(blockMessage) = message {
			#expect(blockMessage.did == "did:plc:cfsbxjl75g6lej53bn2zr7pu")
			#expect(blockMessage.payload.relatedKey == "3lbrtimgrpq2p")
			#expect(blockMessage.payload.record != nil)
			
			if case let .block(content) = blockMessage.payload.record! {
				#expect(content.subjectIdentfier == "did:plc:3wjrxu2x2vsrgtcbyzl3gzf6")
			} else {
				throw MessageHandlerTestsError.contentNotAvailable
			}
		} else {
			throw MessageHandlerTestsError.contentNotAvailable
		}
	}
	
	@Test("Commit // Profile", .tags(.messageHandler))
	func testCommitProfileDecoding() async throws {
		guard let data = MockMessages.commitProfile.data(using: .utf8) else {
			throw MessageHandlerTestsError.invalidJSON
		}
		
		let handler = CommitMessageHandler()
		let message = try await handler.processMessage(content: data, using: jsonDecoder)
		
		if case let .commit(profileMessage) = message {
			#expect(profileMessage.did == "did:plc:wnaugcx6yhjhz7kpz4nm6aay")
			#expect(profileMessage.payload.relatedKey == "self")
			#expect(profileMessage.payload.record != nil)
			
			if case let .profile(content) = profileMessage.payload.record! {
				#expect(content.displayName == "Barkin Senuren")
				
				#expect(content.avatar != nil)
				#expect(content.avatar!.size == 27281)
				
				#expect(content.banner != nil)
				#expect(content.banner!.size == 960383)
				
				#expect(content.pinnedPost != nil)
				#expect(content.pinnedPost!.contentIdentifier == "bafyreihiqkjy42h4zt7hhukzgkcd7roijjygygpiunpvqr4hsnrw7wdguu")
			} else {
				throw MessageHandlerTestsError.contentNotAvailable
			}
		} else {
			throw MessageHandlerTestsError.contentNotAvailable
		}
	}
	
	@Test("Commit // Post (With Images and Reply)", .tags(.messageHandler))
	func testCommitPostDecoding() async throws {
		guard let data = MockMessages.commitPost.data(using: .utf8) else {
			throw MessageHandlerTestsError.invalidJSON
		}
		
		let handler = CommitMessageHandler()
		let message = try await handler.processMessage(content: data, using: jsonDecoder)
		
		if case let .commit(postMessage) = message {
			#expect(postMessage.did == "did:plc:sgk54ktvedr4ultdws5nenbv")
			#expect(postMessage.payload.relatedKey == "3lbeucknjhy2b")
			#expect(postMessage.payload.record != nil)
			
			if case let .post(content) = postMessage.payload.record! {
				#expect(content.text.isEmpty == false)
				
				#expect(content.embeddedContent != nil)
				#expect(content.embeddedContent!.images != nil)
				#expect(content.embeddedContent!.images!.first!.aspectRatio.height == 1124)
				#expect(content.embeddedContent!.images!.first!.image.location.atProtocolLink == "bafkreidktxpsxzwrbsrzajhsdhiw6dz6ie4vek7ts4bfzcagau6sp7h4ju")
				
				#expect(content.languages.count == 1)
				#expect(content.languages.contains("en"))
				
				#expect(content.reply != nil)
				#expect(content.reply!.parent.bskyURL == "at://did:plc:sgk54ktvedr4ultdws5nenbv/app.bsky.feed.post/3lbetphzb362u")
				#expect(content.reply!.root.contentIdentifier == "bafyreiaqg5qpb34om3xlwfeyotabuu4bbbf6pp33g6j4bz7fndyj65gpk4")
			} else {
				throw MessageHandlerTestsError.contentNotAvailable
			}
		} else {
			throw MessageHandlerTestsError.contentNotAvailable
		}
	}
}

extension Tag {
	@Tag static var messageHandler: Tag
}

extension MessageHandlerTests {
	enum MessageHandlerTestsError: Error {
		case invalidJSON
		case contentNotAvailable
	}
}
