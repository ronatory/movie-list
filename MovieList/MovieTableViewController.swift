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
	
	var loadMoreMovies = false
	
	var newMoviesCount: Int = 0
	
	var oldMoviesCount: Int = 0
	
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
		// add movie cell nib
		var cellNib = UINib(nibName: TableViewCellIdentifiers.moviePopularCell, bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.moviePopularCell)
		
		// add nothing found cell nib in case that there are no movies in the response
		cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
		
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
		if movies.count == 0 {
			// no movies, one row for nothing found cell
			return 1
		} else {
			// movies, one row for every movie
			return movies.count
		}
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.moviePopularCell, forIndexPath: indexPath) as! MoviePopularCell
		
		if self.movies.count == 0 {
			return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
		} else {
			let movie = movies[indexPath.row]
			
			// show more lines of text
			cell.movieTitleLabel.numberOfLines = 0
			cell.movieTitleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping

			cell.movieTitleLabel.text = movie.title
			
			if movie.year == 0 {
				cell.movieYearLabel.text = "Unkwown Year"
			} else {
				cell.movieYearLabel.text = movie.year.toString()
			}
			// ranknumber will be shown like this 1., 2. and so on
			let rankNumber = indexPath.row + 1
			cell.movieRankLabel.text = rankNumber.toString() + "."
			
			if let movieImageUrl = movie.poster {
				cell.movieImageView.hnk_setImageFromURL(movieImageUrl)
			}
			
			// show more lines of text
			cell.movieOverviewLabel.numberOfLines = 0
			cell.movieOverviewLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
			
			cell.movieOverviewLabel.text = movie.overview
			
			// set number of movies after first request
			oldMoviesCount = movies.count
		}
		
		// conditions to load the next 10 movies
		// 1. check if user reached the last row
		// 2. is number of movies equal or bigger than 10 (if there are only 8 results, it makes no sense to load more)
		// 3. if the number of movies are higher than 10 compare the number of movies before the last request and after it. if the number is equal then the end is reached
		if indexPath.row == movies.count - 1 && movies.count >= 10 && oldMoviesCount != newMoviesCount {
			
			loadMoreMovies = true
			
			// increase counter for page request
			pageForRequest += 1
			
			fetchAndDisplayTopTenMovies(pageForRequest)
			
			// set the number of movies after load more request
			newMoviesCount = movies.count
		}
		
        return cell
    }
	
	func fetchAndDisplayTopTenMovies(pageForRequest: Int = 1) {

		let application = UIApplication.sharedApplication()
		application.networkActivityIndicatorVisible = true
		self.setLoadingScreen()
		
		TraktAPIManager().fetchTopTenMovies(pageForRequest, callback: { (data, errorString) -> Void in
			application.networkActivityIndicatorVisible = false
			
			// ui should always happen on the main thread
			dispatch_async(dispatch_get_main_queue()) {
				if let unwrappedData: NSData = data {
					
					if self.loadMoreMovies {
						let newLoadedMovies = MovieFactory().createMovies(unwrappedData)
						self.movies.appendContentsOf(newLoadedMovies)						
						
						// set loadMoreMovies back to false if user scrolls again to the end
						self.loadMoreMovies = false
					} else {
						// fill the movies array
						self.movies = MovieFactory().createMovies(unwrappedData)
						
						// reset number of new movies array to zero to start again with comparing
						self.newMoviesCount = 0
					}				
					self.tableView.reloadData()
					self.removeLoadingScreen()
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
