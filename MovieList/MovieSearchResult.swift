//
//  MovieSearchResult.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 26.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import Foundation
import SwiftyJSON

class MovieSearchResult {
	var title: String
	var year: Int
	var poster: NSURL?
	var overview: String
	
	init() {
		self.title = ""
		self.year = 0
		self.overview = ""
	}
	
	convenience init(json: JSON) {
		self.init()
		
		title = json["movie"]["title"].stringValue
		year = json["movie"]["year"].intValue
		overview = json["movie"]["overview"].stringValue
		
		let posterURL = json["movie"]["images"]["poster"]["thumb"].stringValue
		poster = NSURL(string: posterURL)
	}
	
}
