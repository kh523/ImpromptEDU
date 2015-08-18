//
//  SessionControllerViewController.swift
//  ImprompEDU
//
//  Created by Kevin Hui on 8/8/15.
//  Copyright (c) 2015 whatever. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func searchBar(sender: AnyObject) {
        println("hello")
    }
    var numSessions = 0
    var sessionsArray : [Session]?
    //var sessionsArray : [Session] = []
    let ref = Firebase(url: "https://impromptedu.firebaseio.com")
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        println("view will appear")
        getSessions() { array in
            self.sessionsArray = array
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.sessionsArray)
        
        println("view did load")
     
    }
    

    
    func getSessions(completionBlock: [Session] -> Void) { //grabs existing sessions from firebase
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            let json = JSON(snapshot.value)
            let sessions = json["Sessions"]
            
            for session in sessions {
                let sessionData = session.1
                var string : String = sessionData["Begin Time"].string!
                var sessionObject = Session(beginTime: sessionData["Begin Time"].string!, details: sessionData["Details"].string!, endTime: sessionData["End Time"].string!, location: sessionData["Location"].string!, sessionName: sessionData["Session Name"].string!)
                self.sessionsArray!.append(sessionObject)
                self.numSessions++
            }
            
            completionBlock(self.sessionsArray!)
            
            }, withCancelBlock: { error in
                println(error.description)
        })
    }
    
    //MARK: TABLE VIEW SHIT

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sessionsArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        var session : Session = self.sessionsArray![indexPath.row]

        var cell = tableView.dequeueReusableCellWithIdentifier("sessionCell") as! SessionTableViewCell
        
        cell.session = session
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Selected!")
        
        let sessionObject = self.sessionsArray![indexPath.row]
        var sdvc:SessionDetailViewController = SessionDetailViewController()
        var session = self.sessionsArray![indexPath.row].sessionName
        sdvc.sessionstring = "https://impromptedu.firebaseio.com/Sessions/" + session
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
