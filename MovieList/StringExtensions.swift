//
//  StringExtensions.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 27.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import UIKit

extension String {
	
	/**
	To encode a space to %20 for example
	*/
	func escapeString() -> String {
		let escapedString = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		return escapedString
	}
}
