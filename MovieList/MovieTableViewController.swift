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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
		fetchAndDisplayTopTenMovies()
    }
	
	func setupTableView() {
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
		
		TraktAPIManager().fetchTopTenMovies { (data, errorString) -> Void in
			application.networkActivityIndicatorVisible = false
			
			// ui should always happen on the main thread
			dispatch_async(dispatch_get_main_queue()) {
				if let unwrappedData: NSData = data {
					// fill the movies array
					self.movies = MovieFactory().createMovies(unwrappedData)
					self.tableView.reloadData()
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
