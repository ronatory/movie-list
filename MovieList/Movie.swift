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
	var slug: String
	var banner: NSURL?
	var fanart: NSURL?
	var poster: NSURL?
	
	var runtime: Int
	var tagline: String
	var summary: String
	
	private var rating: Float
	var ratingPercent: Int {
		get {
			return Int(rating * 10)
		}
	}
	
	private var genreList: [String]
	var genres: String {
		get {
			return genreList.joinWithSeparator(", ")
		}
	}
	
	init() {
		self.title = ""
		self.year = 0
		self.slug = ""
		self.runtime = 0
		self.genreList = []
		self.rating = 0.0
		self.tagline = ""
		self.summary = ""
	}
	
	convenience init(json: JSON) {
		self.init()
		
		title = json["title"].stringValue
		year = json["year"].intValue
		slug = json["ids"]["slug"].stringValue
		runtime = json["runtime"].intValue
		tagline = json["tagline"].stringValue
		summary = json["overview"].stringValue
		rating = json["rating"].floatValue
		
		let bannerURL = json["images"]["banner"]["full"].stringValue
		banner = NSURL(string: bannerURL)
		
		let fanartURL = json["images"]["fanart"]["thumb"].stringValue
		fanart = NSURL(string: fanartURL)
		
		let posterURL = json["images"]["poster"]["thumb"].stringValue
		poster = NSURL(string: posterURL)
		
		for (_, genre): (String, JSON) in json["genres"] {
			genreList.append(genre.stringValue.capitalizedString)
		}
	}
	
}

