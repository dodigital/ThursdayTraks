//
//  Movie.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 13/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class Movie: NSObject {
    
    var movieID : Int? // theMovieDBID
    var releaseYear : Int?
    var title : String?
    var rating : Float?
    var movieSummary : String?
    var certRating : String?
    var genreArray : [String]?
    var people : [Person]?
    var imagePath : URL?
    var slugId : String?
    var posterData : Data?
    var tagline : String?
    var trailerId : String?
    var youtubeTrailerThumbnail : URL?
    
    init(movieID : Int?, title : String?, rating : Float?, movieSummary : String?, genreArray : [String]?, releaseYear : Int?, certRating : String?, slugId : String?, tagLine : String?, trailerId : String?) {
        
        self.movieID = movieID
        self.title = title
        self.rating = rating
        self.movieSummary = movieSummary
        self.genreArray = genreArray
        self.releaseYear = releaseYear
        self.certRating = certRating
        self.slugId = slugId
        self.tagline = tagLine
        self.trailerId = trailerId
        
        self.youtubeTrailerThumbnail = URL(string: String.init(format: "http://i1.ytimg.com/vi/%@/mqdefault.jpg", trailerId!))!
    }
    
    //
    func updateImagePath(path : String){
        
        self.imagePath = URL(string: String.init(format: "https://image.tmdb.org/t/p/w500%@", path))
        
        self.imagePath?.getImageData(completion: { (data) in
            self.posterData = data
        })
        
    }

    // Convert genre array into one string
    func configureGenreString() -> String {
        
        var genreString : String = ""
        
        for item in genreArray! {
            if item != genreArray?.last {
                genreString = genreString.appending("\(item) ")
            } else {
                genreString = genreString.appending("\(item)")
            }
        }
        
        genreString =  genreString.replacingOccurrences(of: " ", with: " | ")
        return genreString.capitalized
    }
    
    // Set the array of people
    func udpateCast(people : [Person]){
        self.people = people
    }
    
    
}
