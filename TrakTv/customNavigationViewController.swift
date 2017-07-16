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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: Reachability.sharedInstance)
        do{
            try Reachability.sharedInstance?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }

    func setupAlert(){
        
        self.connectivityAlert = UIAlertController(title: "Caution ", message: "Please ensure you are connected to the internet to continue", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        connectivityAlert!.addAction(alertAction)
        
    }
    
    
    func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
    
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
               // is connected
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMovies"), object: nil)
            } else {
                // is connected
            }
        } else {
            self.present(self.connectivityAlert!, animated : true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
