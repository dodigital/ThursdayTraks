//
//  Person.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 15/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class Person: NSObject {

    var name : String?
    var movieId : Int?
    var profileImageData : Data?
    var profileImagePath : URL?
    
    init(name : String?, movieId : Int?) {
        self.name  = name
        self.movieId = movieId
    }
    
    /**
     API documentation stated different resolutions for the profile image, this i.e. 185 seem fit for purpose. See [Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration/)
     */
    
    func getProfilePath(path : String?){
        
        guard path != nil else {
            return
        }
        
        profileImagePath = URL(string: String.init(format: "https://image.tmdb.org/t/p/w185%@", path!))
    }
}
