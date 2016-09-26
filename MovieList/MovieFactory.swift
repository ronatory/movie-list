//
//  MovieFactory.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 25.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import Foundation
import SwiftyJSON

class MovieFactory {
	
	func createMovies(data: NSData) -> [Movie] {
		var movies: [Movie] = []
		let json = JSON(data:data)
		
		for (_, subJson): (String, JSON) in json {
			let movie = Movie(json: subJson)
			movies.append(movie)
		}
		
		return movies
	}
	
}