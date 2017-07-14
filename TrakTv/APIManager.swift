//
//  APIManager.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 13/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit
import Foundation

class APIManager: NSObject {

    static var sharedInstance = APIManager()
    
    enum tracktRequestype {
        case people
        case trendingMovies
        case cast
    }
    
    let tracktApiKey : String = "0e7e55d561c7e688868a5ea7d2c82b17e59fde95fbc2437e809b1449850d4162"
    let movieDBApiKey : String = "52110aa4e42253f08fb2b3944d325448"
    let tracktRequestURL : String = "https://api.trakt.tv/movies/"
    let movieDBRequestURL : String = "https://api.themoviedb.org/3/movie/"
    
    override init() {
        
    }
    
    func performMovieDBRequest(movieID : Int, completion : @escaping (_ didCompleteRequest : Bool, _ imagePath : String?) -> Void){
    
        guard var URL = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)") else {return}
        let URLParams = [
            "api_key": movieDBApiKey,
            "language": "en-US",
            ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                
                do {
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    let posterPath = jsonResult?.object(forKey: "poster_path") as? String
                    
                    completion(true, posterPath)
                    
                } catch let error as NSError {
                    completion(true, nil)
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        }).resume()

    }
    
    /**
     - parameters :
        - requestType:
        - movie : 
     - didCompleteRequest :
     - returningObject :
     */
    func performTrackTRequests(requestType : tracktRequestype, movie : Movie?, completion : @escaping (_ didCompleteReqeust : Bool, _ returningObject : Any?) -> Void){
        
        var requestURL : String = tracktRequestURL
        
        if requestType == .trendingMovies {
            
            requestURL = requestURL.appending("trending?extended=full")
            
        } else if requestType == .people {
            
            let searchString = String.init(format: "%@", movie!.title!.lowercased().replacingOccurrences(of:" ", with: "-"))
            requestURL = requestURL.appending(searchString)
            requestURL = requestURL.appending("/people")
        }
        
        
        var request = URLRequest(url: URL(string: requestURL)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue(tracktApiKey, forHTTPHeaderField: "trakt-api-key")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if (error == nil) {
                // Success
                do {
                    
                    if requestType == .people {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        
                        self.determinePeople(dataDictionary: jsonResult!)
                    
                    } else if requestType == .trendingMovies {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
                        
                        completion(true, self.determineTrendingMovies(dataArray: jsonResult!))
                    }
                } catch let error as NSError {
                    completion(true, nil)
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
                completion(false, nil)
            }
            
        }).resume()
        
    }
    
    /**
     Return an array of People
     */
    func determinePeople(dataDictionary : NSDictionary) -> Void{
    
        let cast = dataDictionary.object(forKey: "cast") as? NSDictionary
        
        guard cast != nil && (cast?.count)! > 0 else {
            return
        }
        
        for items in cast! {
            
        }

    }
    
    /**
     Return an array of movies
     */
    func determineTrendingMovies(dataArray :  NSArray) -> [Movie]?{
        
        var trendingMovies : [Movie] = []
        
        for movie in dataArray {
        
            let movieDictionary = movie as! NSDictionary
            
            let movieDetails = movieDictionary.object(forKey: "movie") as? NSDictionary
            let movieTitle = movieDetails?.object(forKey: "title") as? String
            let movieYear = movieDetails?.object(forKey: "year") as? Int
            
            let ids = movieDetails?.object(forKey: "ids") as? NSDictionary
            let movieDBId = ids?.object(forKey: "tmdb") as? Int
            let movieSummary = movieDetails?.object(forKey: "overview") as? String
            let movieRating = movieDetails?.object(forKey: "rating") as? Float
            let certification = movieDetails?.object(forKey: "certification") as? String
            let genres = movieDetails?.object(forKey: "genres") as? [String]
            
            let trendingMovie = Movie(movieID: movieDBId!, title: movieTitle, rating: movieRating, movieSummary: movieSummary, genreArray: genres, releaseYear: movieYear, certRating: certification)
            
            trendingMovies.append(trendingMovie)
        
        }
        
        return trendingMovies
    }
    
    // Start up all requests
    func initializeRequests(){
        
        // First request for all the Trending movies
        self.performTrackTRequests(requestType: APIManager.tracktRequestype.trendingMovies, movie: nil) { (status, trendingMovies) in
            
            let movies = (trendingMovies as? [Movie])!
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatedTrendingTableView"), object: nil, userInfo: ["movies" : movies])
            }
            
            for trendingMovie in movies {
                
                // Request the details of the movie image
                
               self.performMovieDBRequest(movieID: trendingMovie.movieID!, completion: { (status, imagePath) in
                    
                    guard imagePath != nil else {
                        return
                    }
                    
                    // Update the individual movie objects with the imagepaths
                    trendingMovie.updateImagePath(path: imagePath!)
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatedTrendingTableView"), object: nil, userInfo: ["movies" : movies])
                    }
                })
                
                
                self.performTrackTRequests(requestType: APIManager.tracktRequestype.people, movie: trendingMovie, completion: { (didComplete, people) in
                    
                })
            }
        }

    }
    
}
