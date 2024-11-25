//
//  MockMessages.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Monarca

enum MockMessages {
	static var commit: String {
		"""
		{
		"did": "did:plc:eygmaihciaxprqvxpfvl6flk",
		"time_us": 1725911162329308,
		"kind": "commit",
		"commit": {
				"rev": "3l3qo2vutsw2b",
				"operation": "create",
				"collection": "app.bsky.feed.like",
				"rkey": "3l3qo2vuowo2b",
				"record": {
					"$type": "app.bsky.feed.like",
					"createdAt": "2024-09-09T19:46:02.102Z",
					"subject": {
						"cid": "bafyreidc6sydkkbchcyg62v77wbhzvb2mvytlmsychqgwf2xojjtirmzj4",
						"uri": "at://did:plc:wa7b35aakoll7hugkrjtf3xf/app.bsky.feed.post/3l3pte3p2e325"
						}
					},
				"cid": "bafyreidwaivazkwu67xztlmuobx35hs2lnfh3kolmgfmucldvhd3sgzcqi"
			}
		}
		"""
	}
	
	static var identity: String {
		"""
		{
		"did": "did:plc:ufbl4k27gp6kzas5glhz7fim",
		"time_us": 1725516665234703,
		"kind": "identity",
		"identity": {
			"did": "did:plc:ufbl4k27gp6kzas5glhz7fim",
			"handle": "yohenrique.bsky.social",
			"seq": 1409752997,
			"time": "2024-09-05T06:11:04.870Z"
			}
		}
		"""
	}
	
	static var account: String {
		"""
		{
			"did": "did:plc:ufbl4k27gp6kzas5glhz7fim",
			"time_us": 1725516665333808,
			"kind": "account",
			"account": {
				"active": true,
				"did": "did:plc:ufbl4k27gp6kzas5glhz7fim",
				"seq": 1409753013,
				"time": "2024-09-05T06:11:04.870Z"
			}
		}
		"""
	}
}
