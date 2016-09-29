//
//  SearchTableViewController.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 26.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchViewController:  UIViewController {
	
	// MARK: - Properties

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	
	var movies: [MovieSearchResult] = []
	
	var hasSearched = false
	
	var loadMoreMovies = false
	
	var pageForRequest: Int = 1
	
	/// for comparing, if load more movies is necessary
	var newMoviesCount: Int = 0
	
	/// for comparing, if load more movies is necessary
	var oldMoviesCount: Int = 0
	
	/// for releasing disposables when view is being deallocated
	let disposeBag = DisposeBag()
	
	/// view which contains the loading text and the spinner
	let loadingView = UIView()
	
	/// spinner during load the table view
	let spinner = UIActivityIndicatorView()
	
	/// text during load the table View
	let loadingLabel = UILabel()
	
	// MARK: - Override Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		setupRx()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Methods
	
	func setupView() {
		// add movie search cell nib
		var cellNib = UINib(nibName: TableViewCellIdentifiers.movieSearchCell, bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.movieSearchCell)
		
		// add nothing found cell nib
		cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
		
		// set an estimated row height with automatic dimension in case of longer overview text
		tableView.estimatedRowHeight = 200
		tableView.rowHeight = UITableViewAutomaticDimension
		
		// put the table view under the searchbar
		tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
		
		// change search button from keyboard to a done button
		// no need for it because of the dynamic search (reactivex)
		searchBar.returnKeyType = UIReturnKeyType.Done
	}
	
	func setupRx() {
		// search dynamic via use of reactivex
		searchBar
			.rx_text // observable property
			.throttle(0.5, scheduler: MainScheduler.instance) // wait 0.5 seconds for changes
			.distinctUntilChanged() // check if new value is same as old one
			.filter { $0.characters.count > 0 } // filter for non-empty query
			.subscribeNext { [unowned self] _ in
				
				// user start to search by typing
				self.hasSearched = true
				
				let escapedSearchText = self.searchBar.text!.escapeString()
				
				// set pageForRequest back to 1, cause of new search
				self.pageForRequest = 1
				
				// scroll back to the first row (UX), if user make new search request
				if self.movies.count != 0 {
					self.scrollToFirstRow()
				}
				
				// load only the first 10 movies
				self.fetchAndDisplayMovieSearchResults(searchText: escapedSearchText)
			}
			.addDisposableTo(disposeBag)
	}
	
	func fetchAndDisplayMovieSearchResults(pageForRequest: Int = 1, searchText: String) {
		let application = UIApplication.sharedApplication()
		application.networkActivityIndicatorVisible = true
		self.setLoadingScreen()
		
		TraktAPIManager().fetchMovieSearchResults(pageForRequest, searchText: searchText, callback: { (data, errorString) -> Void in
			application.networkActivityIndicatorVisible = false
			
			// ui should always happen on the main thread
			dispatch_async(dispatch_get_main_queue()) {
				if let unwrappedData: NSData = data {
		
					if self.loadMoreMovies {
						let newLoadedMovies = MovieFactory().createMovieSearchResults(unwrappedData)
						self.movies.appendContentsOf(newLoadedMovies)
						
						// set loadMoreMovies back to false if user scrolls again to the end
						self.loadMoreMovies = false

					} else {
						// fill the movies array
						self.movies = MovieFactory().createMovieSearchResults(unwrappedData)
						
						// reset number of new movies array to zero to start again with comparing
						self.newMoviesCount = 0
					}
					self.tableView.reloadData()
					self.removeLoadingScreen()
				} else if let error = errorString {
					self.showAlert(message: "Something went wrong. Please check your connection and try again.")
					print("\(error)")
				}
			}
		})
	}
	
	func scrollToFirstRow() {
		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
		tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
	}
	
	// set the activity indicator into the main view
	// TODO: refactor DRY, also exists in MovieTableViewController
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
		loadingLabel.textColor = UIColor.whiteColor()
		loadingLabel.textAlignment = NSTextAlignment.Center
		loadingLabel.text = "Loading..."
		loadingLabel.frame = CGRectMake(0, 0, 140, 30)
		loadingLabel.hidden = false
		
		// spinner
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
		spinner.frame = CGRectMake(0, 0, 30, 30)
		spinner.startAnimating()
		
		// add text and spinner to view
		loadingView.addSubview(self.spinner)
		loadingView.addSubview(self.loadingLabel)
		
		tableView.addSubview(loadingView)
	}
	
	// remove activity indicator from the main view
	func removeLoadingScreen() {
		
		// Hides and stops the text, spinner and remove bg color
		spinner.stopAnimating()
		loadingLabel.hidden = true
		loadingView.backgroundColor = nil
	}
}

// MARK: - Extensions

extension SearchViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		
		// only search if user enters a character
		if !searchBar.text!.isEmpty {
			// tells the searchBar not to listen any longer to keyboard inputs
			// keyboard will hide itself until tap again inside searchBar
			searchBar.resignFirstResponder()
		}
	}
}

extension SearchViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if !hasSearched {
			// no search, no rows
			return 0
		} else if movies.count == 0 {
			// no movies, one row for nothing found cell
			return 1
		} else {
			// movies, one row for every movie
			return movies.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.movieSearchCell, forIndexPath: indexPath) as! MovieSearchCell
		
		if movies.count == 0 {
			return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
		} else {
			let movie = movies[indexPath.row]
			
			// show more lines of text
			// TODO: On iPhone 4s and 5 very long titles overlap with year label
			cell.movieTitleLabel.numberOfLines = 0
			cell.movieTitleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
			
			cell.movieTitleLabel.text = movie.title
			if movie.year == 0 {
				cell.movieYearLabel.text = "Unkwown Year"
			} else {
				cell.movieYearLabel.text = movie.year.toString()
			}
			if let movieImageUrl = movie.poster {
				cell.movieImageView.hnk_setImageFromURL(movieImageUrl)
			}
			// show more lines of text
			cell.movieOverviewLabel.numberOfLines = 0
			cell.movieOverviewLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
			
			cell.movieOverviewLabel.text = movie.overview
		}
		
		// set number of movies after first request
		oldMoviesCount = movies.count
		
		// conditions to load the next 10 movies
		// 1. check if user reached the last row
		// 2. is number of movies equal or bigger than 10 (if there are only 8 results, it makes no sense to load more)
		// 3. if the number of movies are higher than 10 compare the number of movies before the last request and after it. if the number is equal then the end is reached
		// TODO: Find a more simple way for checking
		if indexPath.row == movies.count - 1 && movies.count >= 10 && oldMoviesCount != newMoviesCount {
			
			loadMoreMovies = true
			
			// increase counter for page request
			pageForRequest += 1
			
			let escapedSearchText = searchBar.text!.escapeString()
			fetchAndDisplayMovieSearchResults(pageForRequest, searchText: escapedSearchText)
			
			// set the number of movies after load more request
			newMoviesCount = movies.count
		}
		return cell
	}
}
