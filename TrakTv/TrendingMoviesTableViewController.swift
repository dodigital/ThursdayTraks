//
//  TrendingMoviesTableViewController.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 15/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class TrendingMoviesTableViewController: UITableViewController {

    var movies : [Movie] = []
    var animationShown : [Bool]?   /// Array helps identify which rows at index have been animated
    var backToTopButton : UIBarButtonItem!
    var selectedMovie : Movie!
    var pageIndex : Int = 1
    var isDataLoading : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "TRENDING MOVIES"
        self.animationShown = []
        self.backToTopButton =  UIBarButtonItem(image: UIImage(named:"up-arrow"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backToTopButtonWasPressed))
        
        self.navigationItem.setRightBarButton(self.backToTopButton, animated: false)
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(sender:)), name: NSNotification.Name(rawValue: "UpdatedTrendingTableView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(confirmConnectivity(sender:)), name: NSNotification.Name(rawValue: "reloadMovies"), object: nil)
        
        if self.movies.count == 0 {
            self.startMoviesRequest(pageIndex: 1)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UINavigationBar.appearance().barTintColor = UIColor(red:0.16, green:0.17, blue:0.20, alpha:0.4)
    }
    
    func startMoviesRequest(pageIndex : Int){
        
        self.isDataLoading = true

        if (Reachability.sharedInstance?.isReachable)! {
            
            DispatchQueue.global().async {
                
                APIManager.sharedInstance.startTrendingRequests(pageIndex: pageIndex) { (complete) in
                    
                    let personRequestGroup = DispatchGroup()
                    
                    for item in self.movies[(pageIndex-1) * 10...self.movies.count-1] {
                        
                        personRequestGroup.enter()
                        
                        APIManager.sharedInstance.performTrackTRequests(requestType: APIManager.tracktRequestype.people, movie: item, pageIndex: 1, completion: { (didComplete, people) in
                            
                            item.udpateCast(people: people as! [Person])
                            personRequestGroup.leave()
                        })
                    }
                    
                    personRequestGroup.notify(queue: DispatchQueue.global(), execute: {
                        
                        let memberImageGroup = DispatchGroup()
                        for movie in self.movies[(pageIndex-1) * 10...self.movies.count-1] {
                            
                            for member in movie.people! {
                                memberImageGroup.enter()
                                
                                APIManager.sharedInstance.performMovieDBRequest(requestType: APIManager.movieDBRequesttype.people, id: member.movieId!, completion: { (didCompleteRequest, path) in
                                    
                                    member.getProfilePath(path: path)
                                    memberImageGroup.leave()
                                })
                            }
                        }
                        
                        memberImageGroup.notify(queue: DispatchQueue.main, execute: {
                          self.isDataLoading = false
                        })
                    })
                }
            }
            
        } else {
            // the custom navigation controller would handle this, presents an alert at event of no internet connection.
        }
    }
    
    func confirmConnectivity(sender : NSNotification){
        
        if self.movies.count == 0 {
            startMoviesRequest(pageIndex: 0)
        }
        
    }
    
    /// Reset the offset back to top but account for the navigation bar and status bar height
    func backToTopButtonWasPressed(sender: UIBarButtonItem) {
        self.tableView.setContentOffset(CGPoint(x: 0,y: -60), animated: true)
    }
    
    /// Reload the tableview safely in the main thread when movies have been received
    func reloadTableView(sender : NSNotification){
        self.isDataLoading = false
      
        let returnedMovies = sender.userInfo!["movies"] as! [Movie]
        self.movies.append(contentsOf: returnedMovies)
        self.animationShown?.append(contentsOf: [Bool] (repeating: false, count: returnedMovies.count))
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        cell.movie = self.movies[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard self.animationShown!.count > 0 else {
            return
        }
        
        // Animate the tableview cells upwards with a spring animation
        if self.animationShown?[indexPath.row] == false
        {
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 200, 0)
            cell.layer.transform = transform
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                cell.layer.transform = CATransform3DIdentity
            }, completion: nil)
            self.animationShown?[indexPath.row] = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedMovie = self.movies[indexPath.row]
        self.performSegue(withIdentifier: "presentMovie", sender: self)
        
    }
    
    // MARK: - Scrollview Delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        guard let tableView = self.tableView else {return}
        guard let visibleCells = tableView.visibleCells as? [MovieTableViewCell] else {return}
        
        /// The offset here produces the parallax effect as seen on the tableview cells
        for parallaxCell in visibleCells {
            let yOffset = ((tableView.contentOffset.y - parallaxCell.frame.origin.y) / ImageHeight) * OffsetSpeed
            parallaxCell.offset(CGPoint(x: 0.0, y: yOffset))
        }
        
        // Alter the appearance of the backToTopButton based on offset on the scrollview
        let scrollOffset = scrollView.contentOffset.y
        if scrollOffset < 5 {
            // Hide the back to top button
            if backToTopButton.isEnabled == true {
                backToTopButton.isEnabled = false
                
            }
        } else {
            //Show the back to top button
            if backToTopButton.isEnabled == false{
                backToTopButton.isEnabled = true
            }
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                pageIndex += 1
                self.startMoviesRequest(pageIndex: self.pageIndex)
            }
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDataLoading = false
    }

    // MARK: -  Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "presentMovie" {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            let movieDetailVC = segue.destination as! MovieDetailViewController
            movieDetailVC.movie = self.selectedMovie!
           
        }
    }

}
