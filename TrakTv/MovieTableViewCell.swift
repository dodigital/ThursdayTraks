//
//  MovieTableViewCell.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 13/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var subContentView: UIView!
    @IBOutlet weak var movieThumbnail: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var certRating: UILabel!
    @IBOutlet weak var movieSummary: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    var movie : Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.subContentView.layer.cornerRadius = 20
        
        self.movieCollectionView.delegate = self
        self.movieCollectionView.dataSource = self
        
        self.movieCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "castCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupCell(movie : Movie){
    
        guard (movie.title != nil) else {
           return self.movieTitle.text = "N/L"
        }
        
        guard (movie.movieSummary != nil) else {
            return self.movieTitle.text = "N/L"
        }
        guard (movie.certRating != nil) else {
            return self.movieTitle.text = "N/L"
        }
        
        guard (movie.rating != nil) else {
           return self.movieTitle.text = "N/L"
        }
        guard (movie.imagePath != nil) else {
            return
        }
        guard (movie.genreArray != nil ) else {
            return
        }
        
        self.movieTitle.text = movie.title!
        self.movieSummary.text = movie.movieSummary!
        self.certRating.text  = movie.certRating!
        self.movieRatingLabel.text = "\(round(Double(movie.rating!)))"
        
        var genreString = ""
        for genre in movie.genreArray! {
            
        }
        
        self.genreLabel.text = genreString
        
        self.movieThumbnail.downloadedFrom(url: movie.imagePath! as URL)
        
        self.movie = movie
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard self.movie != nil else {
            return 0
       }
        return self.movie!.genreArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as! CastCollectionViewCell
        
        if self.movie!.genreArray!.count > 0 {
          //  cell.titleLabel.text = self.movie?.genreArray![indexPath.row]
            
        }
        
        return cell
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let labelString = self.movie?.genreArray![indexPath.row]
        let stringHeight =  labelString?.height(withConstrainedWidth: 100, font: UIFont(name: "HelveticaNeue-Light", size: 15)!)
        let stringWidth = labelString?.width(withConstraintedHeight: 100, font: UIFont(name: "HelveticaNeue-Light", size: 15)!)
        return CGSize(width: stringWidth!, height: stringHeight!)
    }
    
}
