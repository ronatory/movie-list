//
//  MostPopularMovieTableViewController.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 25.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import UIKit
import Haneke

class MovieTableViewController: UITableViewController {

	var movies: [Movie] = []
	
	var pageForRequest: Int = 1
	
	/// view which contains the loading text and the spinner
	let loadingView = UIView()
	
	/// spinner during load the table view
	let spinner = UIActivityIndicatorView()
	
	/// text during load the table View
	let loadingLabel = UILabel()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		fetchAndDisplayTopTenMovies()
    }
	
	func setupView() {
		// Add movie cell nib
		let cellNib = UINib(nibName: "MoviePopularCell", bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: "MoviePopularCell")
		
		// set an estimated row height with automatic dimension in case of longer overview text
		tableView.estimatedRowHeight = 200
		tableView.rowHeight = UITableViewAutomaticDimension
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
        let cell = tableView.dequeueReusableCellWithIdentifier("MoviePopularCell", forIndexPath: indexPath) as! MoviePopularCell
		
		if self.movies.count == 0 {
			cell.movieTitleLabel.text = "Nothing found"
			cell.movieYearLabel.text = ""
		} else {
			let movie = movies[indexPath.row]
			cell.movieTitleLabel.text = movie.title
			cell.movieYearLabel.text = movie.year.toString()
			let rankNumber = indexPath.row + 1
			// ranknumber will be shown like this 1., 2. and so on
			cell.movieRankLabel.text = rankNumber.toString() + "."
			if let movieImageUrl = movie.poster {
				cell.movieImageView.hnk_setImageFromURL(movieImageUrl)
			}
			
			// show more lines of text
			cell.movieOverviewLabel.numberOfLines = 0
			cell.movieOverviewLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
			
			cell.movieOverviewLabel.text = movie.overview
		}
		
		// check if reached last row then load next 10 movies
		if indexPath.row == movies.count - 1 {
			// TODO: see search view controller, refactor
			fetchAndDisplayMoreTopMovies()
		}
		
        return cell
    }
	
	func fetchAndDisplayTopTenMovies() {
		// TODO: Add activity indicator inside screen when loading movies
		// TODO: Refactor fetch and display methods -> DRY
		let application = UIApplication.sharedApplication()
		application.networkActivityIndicatorVisible = true
		self.setLoadingScreen()
		
		TraktAPIManager().fetchTopTenMovies { (data, errorString) -> Void in
			application.networkActivityIndicatorVisible = false
			
			// ui should always happen on the main thread
			dispatch_async(dispatch_get_main_queue()) {
				if let unwrappedData: NSData = data {
					// fill the movies array
					self.movies = MovieFactory().createMovies(unwrappedData)
					self.tableView.reloadData()
					self.removeLoadingScreen()
				} else if let error = errorString {
					print("\(error)")
				}
			}
		}
	}
	
	func fetchAndDisplayMoreTopMovies() {
		// TODO: Add activity indicator inside screen when loading movies
		// TODO: Refactor fetch and display methods -> DRY
		let application = UIApplication.sharedApplication()
		application.networkActivityIndicatorVisible = true
		
		// increase the number for the page request
		pageForRequest += 1
		TraktAPIManager().fetchMoreTopMovies(pageForRequest, callback: { (data, errorString) -> Void in
			application.networkActivityIndicatorVisible = false
			
			// ui should always happen on the main thread
			dispatch_async(dispatch_get_main_queue()) {
				if let unwrappedData: NSData = data {
					// TODO: Refactor and make only one method for getting the movies like in search view controller, if load more true then append movies if not than just set new movies array
					let newLoadedMovies = MovieFactory().createMovies(unwrappedData)
					// add the new loaded movies to the existing movies array
					self.movies.appendContentsOf(newLoadedMovies)
					self.tableView.reloadData()
				} else if let error = errorString {
					print("\(error)")
				}
			}
		})
	}
	
	// set the activity indicator into the main view
	// TODO: refactor DRY, also exists in SearchViewController
	func setLoadingScreen() {
		
		// set view which contains the loading text and the spinner
		let width: CGFloat = 120
		let height: CGFloat = 30
		let x = (self.tableView.frame.width / 2) - (width / 2)
		let y = (self.tableView.frame.height / 2) - (height / 2) - (self.navigationController?.navigationBar.frame.height)!
		loadingView.frame = CGRectMake(x, y, width, height)
		loadingView.backgroundColor = UIColor.lightGrayColor()
		loadingView.layer.cornerRadius = 10
		
		// loading text
		self.loadingLabel.textColor = UIColor.whiteColor()
		self.loadingLabel.textAlignment = NSTextAlignment.Center
		self.loadingLabel.text = "Loading..."
		self.loadingLabel.frame = CGRectMake(0, 0, 140, 30)
		self.loadingLabel.hidden = false
		
		// spinner
		self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
		self.spinner.frame = CGRectMake(0, 0, 30, 30)
		self.spinner.startAnimating()
		
		// add text and spinner to view
		loadingView.addSubview(self.spinner)
		loadingView.addSubview(self.loadingLabel)
		
		self.tableView.addSubview(loadingView)
		
	}
	
	// remove activity indicator from the main view
	func removeLoadingScreen() {
		
		// Hides and stops the text, spinner and remove bg color
		self.spinner.stopAnimating()
		self.loadingLabel.hidden = true
		loadingView.backgroundColor = nil
		
	}
}
