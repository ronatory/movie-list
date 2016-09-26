//
//  MovieCell.swift
//  MovieList
//
//  Created by Ronny Glotzbach on 25.09.16.
//  Copyright © 2016 Ronny Glotzbach. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

	@IBOutlet weak var movieTitleLabel: UILabel!
	@IBOutlet weak var movieYearLabel: UILabel!
	@IBOutlet weak var movieImageView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
