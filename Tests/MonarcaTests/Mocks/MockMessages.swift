//
//  MockMessages.swift
//  Monarca
//
//  Created by Adolfo Vera Blasco on 25/11/24.
//

import Monarca

enum MockMessages {
	static var commitLike: String {
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
	
	static var commitRepost: String {
		"""
		{
		"did": "did:plc:xgsysfc6hrwpf5nna5fxmj5c",
		"time_us": 1732548420715488,
		"kind": "commit",
		"commit": {
			  "rev": "3lbrtimnuxj25",
			  "operation": "create",
			  "collection": "app.bsky.feed.repost",
			  "rkey": "3lbrtimnp3z25",
			  "record": {
				"$type": "app.bsky.feed.repost",
				"createdAt": "2024-11-25T15:27:00.490Z",
				"subject": {
				  "cid": "bafyreig34fxgp2zg7q7xdffxlkhkmivs4nb4hs4xawjsvmnwuczdhzll5e",
				  "uri": "at://did:plc:yw3qqfa7hrhmwbc6wyrq5u7f/app.bsky.feed.post/3lbrhjs5mmc22"
				}
			  },
			  "cid": "bafyreih72xwq5hubsd3klaisztptozakgwvdoyx4evhgfky7kmknsxdfma"
			}
		}
		"""
	}
	
	static var commitFollow: String {
		"""
		{
		"did": "did:plc:5z3jsxbvy6k3arqa2csj66li",
		"time_us": 1732548420712448,
		"kind": "commit",
		"commit": {
		  "rev": "3lbrtimlney23",
		  "operation": "create",
		  "collection": "app.bsky.graph.follow",
		  "rkey": "3lbrtimldmi23",
		  "record": {
			"$type": "app.bsky.graph.follow",
			"createdAt": "2024-11-25T15:27:00.372721+00:00",
			"subject": "did:plc:vqdfh7svffgjkes4iz54iyz7"
		  },
		  "cid": "bafyreif7gzcoqppuywhgwmt2ewkfdwf2kkrhhsttkk5c5kfypjnl4wpani"
		}
		}	
		"""
	}
	
	static var commitListItem: String {
		"""
		{
		"did": "did:plc:eilpxwyvy34ecczfgi74qgb2",
		"time_us": 1732548420440475,
		"kind": "commit",
		"commit": {
		  "rev": "3lbrtimefut2h",
		  "operation": "create",
		  "collection": "app.bsky.graph.listitem",
		  "rkey": "3lbrtime62t2h",
		  "record": {
			"$type": "app.bsky.graph.listitem",
			"createdAt": "2024-11-25T15:26:59.911Z",
			"list": "at://did:plc:eilpxwyvy34ecczfgi74qgb2/app.bsky.graph.list/3lbrghikb7y2q",
			"subject": "did:plc:bfqd3yciudy4gvho356ajupt"
		  },
		  "cid": "bafyreidquaus54tbrmx6tpq6okf34elwiur6t6xdntxtyl6joiu4uswfg4"
		}
		}
		"""
	}
	
	static var commitBlock: String {
		"""
		{
		"did": "did:plc:cfsbxjl75g6lej53bn2zr7pu",
		"time_us": 1732548420501942,
		"kind": "commit",
		"commit": {
		  "rev": "3lbrtimgxla2p",
		  "operation": "create",
		  "collection": "app.bsky.graph.block",
		  "rkey": "3lbrtimgrpq2p",
		  "record": {
			"$type": "app.bsky.graph.block",
			"createdAt": "2024-11-25T15:27:00.228Z",
			"subject": "did:plc:3wjrxu2x2vsrgtcbyzl3gzf6"
		  },
		  "cid": "bafyreigkllcp65ptg6lvrlrs4u5kdpv7vspg5wdkbbmd5ghpdkuupbhuyq"
		}
		}
		"""
	}
	
	static var commitProfile: String {
		#"""
		{
		"did": "did:plc:wnaugcx6yhjhz7kpz4nm6aay",
		"time_us": 1732548420459803,
		"kind": "commit",
		"commit": {
		  "rev": "3lbrtimgiuc2k",
		  "operation": "update",
		  "collection": "app.bsky.actor.profile",
		  "rkey": "self",
		  "record": {
			"$type": "app.bsky.actor.profile",
			"avatar": {
			  "$type": "blob",
			  "ref": {
				"$link": "bafkreifu75d26nkquv3dy5qvta2ilgxpryy6gjj6kxcsi76j4nynycjkgu"
			  },
			  "mimeType": "image/jpeg",
			  "size": 27281
			},
			"banner": {
			  "$type": "blob",
			  "ref": {
				"$link": "bafkreido6rg5woiboybkrnx5garteruoosfliozdst5mfbfjvlpvyfup4u"
			  },
			  "mimeType": "image/jpeg",
			  "size": 960383
			},
			"createdAt": "2024-11-13T16:47:58.527Z",
			"description": "Screenwriter, Film Editor, AI enthusiast, ₿ day trader. \n\nhttps://www.imdb.com/name/nm2343594/\n\nhttps://suno.com/@senurenbarkin",
			"displayName": "Barkin Senuren",
			"pinnedPost": {
			  "cid": "bafyreihiqkjy42h4zt7hhukzgkcd7roijjygygpiunpvqr4hsnrw7wdguu",
			  "uri": "at://did:plc:wnaugcx6yhjhz7kpz4nm6aay/app.bsky.feed.post/3lbrtg5nvmc2u"
			}
		  },
		  "cid": "bafyreidcol5on37t76pmzormcvkchdl6fyrfkdqgxyfmkrdrns6ttsl5be"
		}
		}
		"""#
	}
	
	static var commitPost: String {
		"""
		{
		"did": "did:plc:sgk54ktvedr4ultdws5nenbv",
		"time_us": 1732102615126359,
		"kind": "commit",
		"commit": {
		  "rev": "3lbeucknqcq2b",
		  "operation": "create",
		  "collection": "app.bsky.feed.post",
		  "rkey": "3lbeucknjhy2b",
		  "record": {
			"$type": "app.bsky.feed.post",
			"createdAt": "2024-11-20T11:36:54.105Z",
			"embed": {
			  "$type": "app.bsky.embed.images",
			  "images": [
				{
				  "alt": "",
				  "aspectRatio": { "height": 1124, "width": 2000 },
				  "image": {
					"$type": "blob",
					"ref": {
					  "$link": "bafkreidktxpsxzwrbsrzajhsdhiw6dz6ie4vek7ts4bfzcagau6sp7h4ju"
					},
					"mimeType": "image/jpeg",
					"size": 550270
				  }
				}
			  ]
			},
			"langs": ["en"],
			"reply": {
			  "parent": {
				"cid": "bafyreiaqg5qpb34om3xlwfeyotabuu4bbbf6pp33g6j4bz7fndyj65gpk4",
				"uri": "at://did:plc:sgk54ktvedr4ultdws5nenbv/app.bsky.feed.post/3lbetphzb362u"
			  },
			  "root": {
				"cid": "bafyreiaqg5qpb34om3xlwfeyotabuu4bbbf6pp33g6j4bz7fndyj65gpk4",
				"uri": "at://did:plc:sgk54ktvedr4ultdws5nenbv/app.bsky.feed.post/3lbetphzb362u"
			  }
			},
			"text": "i exactly remembered where I put them"
		  },
		  "cid": "bafyreifm4otyvufi2ttmphbnfs2eiv3vnt4xzu7niro5pchjuyji3jb6ou"
		}
		}
		"""
	}
	
	static var commitPostWithFacet: String {
		"""
		{
		"did": "did:plc:4imeuitzy2wizyngczhdguzn",
		"time_us": 1732570668538243,
		"kind": "commit",
		"commit": {
		  "rev": "3lbsi7n2zam2x",
		  "operation": "create",
		  "collection": "app.bsky.feed.post",
		  "rkey": "3lbsi7n2vdm2x",
		  "record": {
			"$type": "app.bsky.feed.post",
			"createdAt": "2020-12-27T08:31:25.000Z",
			"embed": {
			  "$type": "app.bsky.embed.images",
			  "images": [
				{
				  "alt": "",
				  "image": {
					"$type": "blob",
					"ref": {
					  "$link": "bafkreie6n2bri6mougcmvf6awcxdmhbhbi7sac65pfifc3rwvu24rzjlii"
					},
					"mimeType": "image/jpeg",
					"size": 87197
				  }
				},
				{
				  "alt": "",
				  "image": {
					"$type": "blob",
					"ref": {
					  "$link": "bafkreifie45m3rycjzlhkusud46kkjajndcklodrx6gakl35r4rjbl7bnm"
					},
					"mimeType": "image/jpeg",
					"size": 93603
				  }
				}
			  ]
			},
			"facets": [
			  {
				"features": [
				  {
					"$type": "app.bsky.richtext.facet#link",
					"uri": "https://www.coronawarn.app/en/faq/#backup"
				  }
				],
				"index": { "byteEnd": 208, "byteStart": 167 }
			  }
			],
			"reply": {
			  "parent": {
				"cid": "bafyreid2ljtfkna2l7n4yepajxfz4faoqnayqziy3yqeaxzwl5fq2dscxu",
				"uri": "at://did:plc:4imeuitzy2wizyngczhdguzn/app.bsky.feed.post/3lbsi7hdoji2u"
			  },
			  "root": {
				"cid": "bafyreiha6xpo57xnui667gm5aqtrzwk672mvtbhcdkr2wt3nlelir5yf74",
				"uri": "at://did:plc:4imeuitzy2wizyngczhdguzn/app.bsky.feed.post/3lbo6yr2wsl2m"
			  }
			},
			"text": "Die FAQ der Corona-Warn-App empfiehlt beim Smartphone-Wechsel übrigens, das alte Smartphone noch 14 Tage lang parallel weiterzuverwenden und regelmäßig zu checken: https://www.coronawarn.app/en/faq/#backup"
		  },
		  "cid": "bafyreiai3a6tihe5tuoafk2t7ru5heuz2trypcuogd7j4qtqylary5idku"
		}
		}
		"""
	}
	
	static var commitDeleted: String {
		"""
		{
			"did":"did:plc:k74amn5fp3ap7dmaceolhpyi",
			"time_us":1732571416879146,
			"kind":"commit",
			"commit":{
				"rev":"3lbsivxh5kg2x",
				"operation":"delete",
				"collection":"app.bsky.graph.follow",
				"rkey":"3lawjozzktt2s"
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
