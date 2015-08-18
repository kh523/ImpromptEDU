//
//  LogInViewController.swift
//  ImprompEDU
//
//  Created by Kevin Hui on 8/8/15.
//  Copyright (c) 2015 whatever. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class LogInViewController: UIViewController {
    
    var numSessions = 0
    var sessionsArray : [Session] = []
    let ref = Firebase(url: "https://impromptedu.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSessions() { array in
            self.sessionsArray = array
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButton(sender: AnyObject) {
        if (self.sessionsArray.count != 0) {
            performSegueWithIdentifier("showSessions", sender: self)
        }
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showSessions") {
            let nvc : UINavigationController = segue.destinationViewController as! UINavigationController
            let svc : SessionViewController = nvc.viewControllers[0] as! SessionViewController
            svc.sessionsArray = self.sessionsArray
        }
    }

    func getSessions(completionBlock: [Session] -> Void) { //grabs existing sessions from firebase
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            let json = JSON(snapshot.value)
            let sessions = json["Sessions"]
            
            for session in sessions {
                let sessionData = session.1
                var string : String = sessionData["Begin Time"].string!
                var sessionObject = Session(beginTime: sessionData["Begin Time"].string!, details: sessionData["Details"].string!, endTime: sessionData["End Time"].string!, location: sessionData["Location"].string!, sessionName: sessionData["Session Name"].string!)
                self.sessionsArray.append(sessionObject)
                self.numSessions++
            }
            
            completionBlock(self.sessionsArray)
            
            }, withCancelBlock: { error in
                println(error.description)
        })
    }

}

