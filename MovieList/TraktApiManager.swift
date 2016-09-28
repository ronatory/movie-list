//
//  TraktApiManager.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 25.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import Foundation

private let urlString = "https://api.trakt.tv/movies/popular?extended=full,images&page=1&limit=10"

private let traktAPIKey = "ad005b8c117cdeee58a1bdb7089ea31386cd489b21e14b19818c91511f12a086"

private let moviesPerRequest = 10

class TraktAPIManager {
	
	private let session = NSURLSession.sharedSession()
	
	// TODO: Refactor fetch methods -> DRY
	func fetchTopTenMovies(callback: (NSData?, String?) -> Void) {
		
		let url = NSURL(string: urlString)!
		let request = moviesURLRequest(url)
		let task = session.dataTaskWithRequest(request) {
			(data, response, error) -> Void in
			let httpResponse = response as? NSHTTPURLResponse
			
			if error != nil {
				callback(nil, "Error \(httpResponse): \(error!.localizedDescription)")
			} else {
				callback(data, nil)
			}
		}
		task.resume()
	}
	
	func fetchMoreTopMovies(page: Int, callback: (NSData?, String?) -> Void) {
		
		let urlStringForMoreTopMovies = "https://api.trakt.tv/movies/popular?extended=full,images&page=\(page)&limit=\(moviesPerRequest)"
		
		let url = NSURL(string: urlStringForMoreTopMovies)!
		let request = moviesURLRequest(url)
		let task = session.dataTaskWithRequest(request) {
			(data, response, error) -> Void in
			let httpResponse = response as? NSHTTPURLResponse
			
			if error != nil {
				callback(nil, "Error \(httpResponse): \(error!.localizedDescription)")
			} else {
				callback(data, nil)
			}
		}
		task.resume()
	}
	
	func fetchMovieSearchResults(page: Int, searchText: String, callback: (NSData?, String?) -> Void) {
		
		let urlStringForMovieSearchResults = "https://api.trakt.tv/search/movie?query=\(searchText)&extended=full,images&page=\(page)&limit=\(moviesPerRequest)"
		
		let url = NSURL(string: urlStringForMovieSearchResults)!
		let request = moviesURLRequest(url)
		let task = session.dataTaskWithRequest(request) {
			(data, response, error) -> Void in
			let httpResponse = response as? NSHTTPURLResponse
			
			if error != nil {
				callback(nil, "Error \(httpResponse): \(error!.localizedDescription)")
			} else {
				callback(data, nil)
			}
		}
		task.resume()
	}
	
	func moviesURLRequest(url: NSURL) -> NSMutableURLRequest {
		let request = NSMutableURLRequest(URL: url)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("2", forHTTPHeaderField: "trakt-api-version")
		request.addValue(traktAPIKey, forHTTPHeaderField: "trakt-api-key")
		return request
	}
}