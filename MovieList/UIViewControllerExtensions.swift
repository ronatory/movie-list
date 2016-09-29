//
//  UIViewControllerExtensions.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 29.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import UIKit

extension UIViewController {
	
	/**
	Create an alert
	*/
	func showAlert(title: String = "", message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alert.addAction(action)
		self.presentViewController(alert, animated: true, completion: nil)
	}
}
