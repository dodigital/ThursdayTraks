//
//  ViewController.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 13/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var movies : [Movie] = []
    
    @IBOutlet weak var trendingMoviewsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(sender:)), name: NSNotification.Name(rawValue: "UpdatedTrendingTableView"), object: nil)
        
        APIManager.sharedInstance.initializeRequests()
        
    }
    
    func reloadTableView(sender : NSNotification){
    
        let movies = sender.userInfo!["movies"] as! [Movie]
        
        self.movies = movies
        
        self.trendingMoviewsTableView.reloadData()
    }
    
    
    // MARK:-  TABLEVIEW DELAGATE & DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 454
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        let cellMovie = self.movies[indexPath.row]
        cell.movie = cellMovie
        cell.setupCell(movie: cellMovie)
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

