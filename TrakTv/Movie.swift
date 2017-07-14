//
//  Movie.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 13/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class Movie: NSObject {
    
    var movieID : Int?   // theMovieDBID
    var releaseYear : Int?
    var title : String?
    var rating : Float?
    var movieSummary : String?
    var certRating : String?
    var genreArray : [String]?
    
    var imagePath : NSURL?
    
    init(movieID : Int, title : String?, rating : Float?, movieSummary : String?, genreArray : [String]?, releaseYear : Int?, certRating : String?) {
        self.movieID = movieID
        self.title = title
        self.rating = rating
        self.movieSummary = movieSummary
        self.genreArray = genreArray
        self.releaseYear = releaseYear
        self.certRating = certRating
    }
    
    func updateImagePath(path : String){
        self.imagePath = NSURL(string: String.init(format: "https://image.tmdb.org/t/p/w185%@", path))
    }
}
