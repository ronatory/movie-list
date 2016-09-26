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
	var slug: String
	var banner: NSURL?
	var fanart: NSURL?
	var poster: NSURL?
	
	var runtime: Int
	var tagline: String
	var overview: String
	
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
		self.overview = ""
	}
	
	convenience init(json: JSON) {
		self.init()
		
		title = json["movie"]["title"].stringValue
		year = json["movie"]["year"].intValue
		slug = json["movie"]["ids"]["slug"].stringValue
		runtime = json["movie"]["runtime"].intValue
		tagline = json["movie"]["tagline"].stringValue
		overview = json["movie"]["overview"].stringValue
		rating = json["movie"]["rating"].floatValue
		
		let bannerURL = json["movie"]["images"]["banner"]["full"].stringValue
		banner = NSURL(string: bannerURL)
		
		let fanartURL = json["movie"]["images"]["fanart"]["thumb"].stringValue
		fanart = NSURL(string: fanartURL)
		
		let posterURL = json["movie"]["images"]["poster"]["thumb"].stringValue
		poster = NSURL(string: posterURL)
		
		for (_, genre): (String, JSON) in json["movie"]["genres"] {
			genreList.append(genre.stringValue.capitalizedString)
		}
	}
	
}
