//
//  MovieSearchCell.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 28.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import UIKit

class MovieSearchCell: UITableViewCell {
	
	@IBOutlet weak var movieTitleLabel: UILabel!
	@IBOutlet weak var movieYearLabel: UILabel!
	@IBOutlet weak var movieImageView: UIImageView!
	@IBOutlet weak var movieOverviewLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
