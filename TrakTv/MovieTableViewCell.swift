//
//  MovieTableViewCell.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 13/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

let ImageHeight: CGFloat = 200.0
let OffsetSpeed: CGFloat = 25.0

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var moviewThumbnail: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var certRatingLabel: UILabel!
    
    // Once we have the movie object, update the UI
    var movie : Movie! {
        didSet {
            self.setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setupUI(){
    
        guard movie.imagePath != nil else {
            return
        }
        
        self.starRating.rating = Double(Float(self.movie.rating!*10)*5/Float(100))
        self.moviewThumbnail.downloadedFrom(url: movie.imagePath! as URL, contentMode: UIViewContentMode.scaleAspectFill)
        self.movieTitleLabel.text = movie.title
        self.genreLabel.text = movie.configureGenreString()
        self.certRatingLabel.text = movie.certRating
    }

    // TODO
    func configureStarRatingView(){
    
    }
    
    // Called in the parent view controller to set the parallax effect
    func offset(_ offset: CGPoint)
    {
        moviewThumbnail.frame = self.moviewThumbnail.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
    
    
}
