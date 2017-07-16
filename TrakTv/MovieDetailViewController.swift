//
//  MovieDetailViewController.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 16/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movie : Movie! /// Selected movie
    
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var movieDetailTableView: UITableView!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movieDictionary : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backGroundImageView.image = UIImage(data: self.movie.posterData!, scale: 1.5)
        self.posterImageView.image = UIImage(data: self.movie.posterData!)
        self.tagLineLabel.text = self.movie.tagline!
        
        self.movieDetailTableView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0)
        self.setupTableCellDetails()

    }
    
    // Aim is to hide the navigation bar background whislt showing the back button for navigation
    func setupNavigationBarAppearance(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.20, alpha:0.4)
    }
    
    // Ensure the image for the youtube thumbnail is downloaded, when complete, reload the table view
    func setupTableCellDetails() -> Void {
    
        /// Not entirely the very best solution, a revise may include serializing the properties of the Movie object, creating a dictionary and pulling needed values from there.
        
        self.movie.youtubeTrailerThumbnail!.getImageData(completion: { (data) in
            
            DispatchQueue.main.async {
                
                self.movieDictionary = [
                    
                    self.movie.title!.uppercased(),
                    self.movie.configureGenreString(),
                    self.movie.movieSummary!,
                    data,
                    String.init(format: "Certification : %@", self.movie.certRating!.uppercased()),
                    String.init(format: "Released : %d", self.movie.releaseYear!),
                    "Crew",
                    "Cast"
                    
                ]
                
                self.movieDetailTableView.reloadData()
                
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
        Presents the custom pop up displaying the cast or crew of a selected movie
        - parameters:
            - popUpType : enum value which helps identify type of Person objects to display
     */
    func presentPopup(popUpType : peopleSelection){

        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "showCastCrewView") as! ProfileViewController
        
        popOverVC.movie = self.movie!
        popOverVC.peopleSelectionType = popUpType
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.bounds
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self.tabBarController)

    }
    
}


extension MovieDetailViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "detailsInfoCell", for: indexPath)
      
        if self.movieDictionary.count > 0 {
        
            // If on third row via indexpath and the object stored across is data then show the youtube thumbnail (Buggy, shows on tap of the cell (not a priority at this stage FYI)
            if indexPath.row == 3 {
            
                if let data = self.movieDictionary[indexPath.row] as? Data {
                    
                    let  trailerCell = tableView.dequeueReusableCell(withIdentifier: "trailerThumbCell", for: indexPath) as! TrailerTableViewCell
                    trailerCell.trailerThumbnail.image = UIImage(data: data)
                    return trailerCell
                    
                }
                
            } else {
                
                // if at the first index, ensure we are setting the font sizes
                if indexPath.row == 0 {
                    
                    cell.textLabel?.text = (self.movieDictionary[indexPath.row] as! String)
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 19)
                }
                
                cell.textLabel?.text = (self.movieDictionary[indexPath.row] as! String)
                cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
                
                if indexPath.row == 6 || indexPath.row == 7 {
                    
                    cell.accessoryType = .disclosureIndicator
                    cell.accessoryView?.tintColor = .white
                }
            }
            
        }
       
        return cell
    }

}

extension MovieDetailViewController : UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieDictionary.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3 {
            return 150
        }

        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present the custom pop ups and set the type accordingly
        if indexPath.row == 6 {
            self.presentPopup(popUpType: .crew)
        }
        else if indexPath.row == 7 {
            self.presentPopup(popUpType: .cast)
        }
    }
}
