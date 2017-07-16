//
//  customViewController.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 16/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class customNavigationViewController: UINavigationController {

    var connectivityAlert : UIAlertController?
    
    var isReachable : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAlert()
        
        // Setup notifications for internet connectivity
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: Reachability.sharedInstance)
        
        do{
            try Reachability.sharedInstance?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }

    // Set up connection error alert
    func setupAlert(){
        
        self.connectivityAlert = UIAlertController(title: "Caution ", message: "Please ensure you are connected to the internet to continue", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        connectivityAlert!.addAction(alertAction)
        
    }
    
    /**
     If connected post the notification to the TrendingMoviesTableViewController
     else
     Present the alert, given this is a navigation controller, the alert will be presented on all uiviewcontrollers in event of failure to connect.
     */
    func reachabilityChanged(sender: Notification) {
        
        let reachability = sender.object as! Reachability
    
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
               // is connected
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMovies"), object: nil)
            } else {
                // is connected
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMovies"), object: nil)
            }
        } else {
            self.present(self.connectivityAlert!, animated : true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
