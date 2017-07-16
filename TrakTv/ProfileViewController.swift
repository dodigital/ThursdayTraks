//
//  ProfileViewController.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 16/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit


enum peopleSelection {
    case crew, cast
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilesCollectionView: UICollectionView!
    
    var moviePosterData : Data!
    var persons : [Person]!
    var movie : Movie!
    var peopleSelectionType : peopleSelection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        if peopleSelectionType == .crew {
            self.titleLabel.text = "CREW"
            self.persons = self.movie.people?.filter({$0.isKind(of: CrewMember.self)})
        }
        else if peopleSelectionType == .cast {
            self.titleLabel.text = "CAST"
            self.persons = self.movie.people?.filter({$0.isKind(of: CastMember.self)})
        }
        
        self.showAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
            
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.willMove(toParentViewController: nil)
                
                self.view.removeFromSuperview()
                // Notify Child View Controller
                self.removeFromParentViewController()
                }
        });
    }

    @IBAction func userTappedCancel(_ sender: Any) {
        self.removeAnimate()
    }
}


extension ProfileViewController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.persons.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width / 2.0
        collectionViewSize.height = collectionViewSize.height / 3.0
        return collectionViewSize
    }
}

extension ProfileViewController : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
        
        let person = self.persons[indexPath.item]
        
        cell.personNameLabel.text = person.name
        
        if person.profileImagePath != nil {
            cell.profileImageView.contentMode = .scaleAspectFill
            cell.profileImageView.downloadedFrom(url: person.profileImagePath!)
        } else {
            cell.profileImageView.contentMode = .scaleAspectFit
            cell.profileImageView.image = UIImage(named: "userUnavailable")
        }
        
        return cell
        
        
    }
}
