//
//  Movie.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 25.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie {
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
		
		title = json["title"].stringValue
		year = json["year"].intValue
		overview = json["overview"].stringValue
		
		let posterURL = json["images"]["poster"]["thumb"].stringValue
		poster = NSURL(string: posterURL)
	}
	
}

