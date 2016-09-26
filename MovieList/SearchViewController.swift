//
//  SearchTableViewController.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 26.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import UIKit

class SearchViewController:  UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	
	var movies: [MovieSearchResult] = []
	
	var hasSearched = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Add movie cell nib
		let cellNib = UINib(nibName: "MovieCell", bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: "MovieCell")
		tableView.rowHeight = 80
		
		// put the table view a little bit higher
		tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0,
		                                      right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func fetchAndDisplayMovieSearchResults(searchText: String) {
		// TODO: Add activity indicator inside screen when loading movies
		// TODO: Refactor fetch and display methods -> DRY
		let application = UIApplication.sharedApplication()
		application.networkActivityIndicatorVisible = true
		
		TraktAPIManager().fetchMovieSearchResults(searchText, callback: { (data, errorString) -> Void in
			application.networkActivityIndicatorVisible = false
			
			// ui should always happen on the main thread
			dispatch_async(dispatch_get_main_queue()) {
				if let unwrappedData: NSData = data {
					// fill the movies array
					self.movies = MovieFactory().createMovieSearchResults(unwrappedData)
					self.tableView.reloadData()
				} else if let error = errorString {
					print("\(error)")
				}
			}
		})
	}
}

extension SearchViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		
		// only search if user enters a character
		if !searchBar.text!.isEmpty {
			// tells the searchBar not to listen any longer to keyboard inputs
			// keyboard will hide itself until tap again inside searchBar
			searchBar.resignFirstResponder()
			
			hasSearched = true
			
			// to encode a space to a + for example, so that the app don't crash
			let escapedSearchText = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
			
			fetchAndDisplayMovieSearchResults(escapedSearchText)
		}
	}
}

extension SearchViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		// TODO: Refactor shorter way, use an enum
		if !hasSearched {
			return 0
		} else if movies.count == 0 {
			return 1
		} else {
			return movies.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
		
		if movies.count == 0 {
			cell.movieTitleLabel.text = "Nothing found"
			cell.movieYearLabel.text = ""
		} else {
			let movie = movies[indexPath.row]
			cell.movieTitleLabel.text = movie.title
			cell.movieYearLabel.text = movie.year.toString()
			if let movieImageUrl = movie.poster {
				cell.movieImageView.hnk_setImageFromURL(movieImageUrl)
			}
		}
		return cell
	}
}

extension SearchViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		// deselect row with an animation
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		// make sure that user can only select rows with actual search result
		if movies.count == 0 {
			return nil
		} else {
			return indexPath
		}
	}
}