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
    }
    
    enum movieDBRequesttype {
        case movies
        case people
    }
    
    let tracktApiKey : String = "0e7e55d561c7e688868a5ea7d2c82b17e59fde95fbc2437e809b1449850d4162"
    let movieDBApiKey : String = "52110aa4e42253f08fb2b3944d325448"
    let tracktRequestURL : String = "https://api.trakt.tv/movies/"
    let movieDBRequestURL : String = "https://api.themoviedb.org/3/movie/"
    
    override init() {
        
    }
    
    /**
     - parameters: 
        - requestType :
        - id :
        - didCompleteRequest :
        - imagePath
     */
    func performMovieDBRequest(requestType : movieDBRequesttype, id : Int, completion : @escaping (_ didCompleteRequest : Bool, _ imagePath : String?) -> Void){
    
        var url : URL!
        
        if requestType == .movies {
            url = URL(string: "https://api.themoviedb.org/3/movie/\(id)")
        } else if requestType == .people {
            url = URL(string: "https://api.themoviedb.org/3/person/\(id)")
        }
        
        let URLParams = [
            "api_key": movieDBApiKey,
            "language": "en-US",
            ]
        
        url = url.appendingQueryParameters(URLParams)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                
                do {
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    if requestType == .movies {
                        
                        let posterPath = jsonResult?.object(forKey: "poster_path") as? String
                        completion(true, posterPath)
                        
                    } else if requestType == .people {
                        
                        let posterPath = jsonResult?.object(forKey: "profile_path") as? String
                        completion(true, posterPath)
                    }
                    
                    
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
     
     The intention is to use the same function to execute functions related to the TrackT API
     - parameters :
        - requestType: people / movies
        - movie : current movie
     - didCompleteRequest : completion completed
     - returningObject : Using generics proves more efficient if expecting different types of returning objects.
     */
    func performTrackTRequests(requestType : tracktRequestype, movie : Movie?, pageIndex : Int?, completion : @escaping (_ didCompleteReqeust : Bool, _ returningObject : Any?) -> Void){
        
        var requestURL : String = tracktRequestURL
        
        
        //trending?page=1&limit=10&extended=full
        
        if requestType == .trendingMovies {
            
            requestURL = requestURL.appending("trending?page=\(pageIndex!)&limit=10extended=full")
            
        } else if requestType == .people {
            
            requestURL = requestURL.appending(movie!.slugId!)
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
                        
                        completion(true, self.determinePeople(dataDictionary: jsonResult!))
                        
                    } else if requestType == .trendingMovies {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
                        
                        completion(true, self.determineTrendingMovies(dataArray: jsonResult!))
                    }
                } catch let error as NSError {
                    completion(true, nil)
                    print(error.localizedDescription)
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
     Determine the people i.e cast and crew members for a movie and return
     */
    func determinePeople(dataDictionary : NSDictionary) -> [Person] {
    
        let cast = dataDictionary.object(forKey: "cast") as? NSArray
        
        var people : [Person] = []

        for item in cast! {
            
            let person = item as! NSDictionary
            let characterName = person.object(forKey: "character") as? String
            let personInfo = person.object(forKey: "person") as? NSDictionary
            let actorName = personInfo?.object(forKey: "name") as? String
            let ids = personInfo?.object(forKey: "ids") as? NSDictionary
            let movieId = ids?.object(forKey: "tmdb") as? Int
            
            let castMember = CastMember(movieId: movieId!, name: actorName!, characterName:
                characterName!)
            
            people.append(castMember)
        }
        
        let crew = dataDictionary.object(forKey: "crew") as? NSDictionary
        
        var crewMember : CrewMember?
        
        for (key,value) in crew! {
            
            let department = value as! [NSDictionary]
            
            for item in department {
                
                let crewItem = item as NSDictionary
                let jobTitle = crewItem.object(forKey: "job") as? String
                let personDetail = crewItem.object(forKey: "person") as? NSDictionary
                let crewMemberName = personDetail?.object(forKey: "name") as? String
                let ids = personDetail?.object(forKey: "ids") as? NSDictionary
                let movieId = ids?.object(forKey: "tmdb") as? Int
                
                crewMember = CrewMember(movieId: movieId!, name: crewMemberName!, job: jobTitle!, department: key as! String)
            }
        
            people.append(crewMember!)
        }
        
        return people
        
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
            let slugId = ids?.object(forKey: "slug") as? String
            let movieSummary = movieDetails?.object(forKey: "overview") as? String
            let movieRating = movieDetails?.object(forKey: "rating") as? Float
            let certification = movieDetails?.object(forKey: "certification") as? String
            let genres = movieDetails?.object(forKey: "genres") as? [String]
            let tagLine = movieDetails?.object(forKey: "tagline") as? String
            
            let trailer = movieDetails?.object(forKey: "trailer") as? String
            let trailerId = trailer?.components(separatedBy: "=").last
            
            let trendingMovie = Movie(
                movieID: movieDBId!,
                title: movieTitle,
                rating: movieRating,
                movieSummary: movieSummary,
                genreArray: genres,
                releaseYear: movieYear,
                certRating: certification,
                slugId : slugId, tagLine : tagLine, trailerId: trailerId!)
            
            trendingMovies.append(trendingMovie)
        
        }
        
        return trendingMovies
    }
    
    func startTrendingRequests(completion : @escaping (_ requestComplete : Bool) -> Void){
        
        // First request for all the Trending movies
        self.performTrackTRequests(requestType: APIManager.tracktRequestype.trendingMovies, movie: nil) { (status, trendingMovies) in
            
            let movies = (trendingMovies as? [Movie])!
            
            let movieRequestGroup = DispatchGroup()
            
            for trendingMovie in movies {
                movieRequestGroup.enter()
                // Request the details of the movie image
               self.performMovieDBRequest(requestType: .movies, id: trendingMovie.movieID!, completion: { (status, imagePath) in
                    guard imagePath != nil else {
                        return
                    }
                    // Update the individual movie objects with the imagepaths
                    trendingMovie.updateImagePath(path: imagePath!)
                    movieRequestGroup.leave()
                })
            }
            
            movieRequestGroup.notify(queue: DispatchQueue.main, execute: {
               
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatedTrendingTableView"), object: nil, userInfo: ["movies" : movies])
                completion(true)
                
            })
        }

    }
    
}
