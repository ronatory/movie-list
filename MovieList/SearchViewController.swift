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
	
	var movies: [Movie] = []
	
	var hasSearched = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// put the table view a little bit higher
		tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0,
		                                      right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		// tells the searchBar not to listen any longer to keyboard inputs
		// keyboard will hide itself until tap again inside searchBar
		searchBar.resignFirstResponder()
		
		hasSearched = true
		print("The search text is: '\(searchBar.text!)'")
		
		for i in 0...2 {
			
			let movie = Movie()
			movie.title = String(format: "Fake Result %d for", i)
			
			movie.overview = searchBar.text!
			
			movies.append(movie)
		}
		tableView.reloadData()
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
		
		
		let cellIdentifier = "SearchResultCell"
		var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
		
		if cell == nil {
			cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
		}
		
		if movies.count == 0 {
			cell.textLabel!.text = "(Nothing found)"
			cell.detailTextLabel!.text = ""
			
		} else {
			let movie = movies[indexPath.row]
			cell.textLabel!.text = movie.title
			cell.detailTextLabel!.text = movie.overview
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