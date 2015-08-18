//
//  CreateGroupViewController.swift
//  ImprompEDU
//
//  Created by Kevin Hui on 8/8/15.
//  Copyright (c) 2015 whatever. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var details: UITextField!
    
    
    @IBOutlet weak var sessionName: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var beginTimePicker: UIDatePicker!

    var numSessions = 0
    var sessionsArray : [Session] = []
    let ref = Firebase(url: "https://impromptedu.firebaseio.com")
    
    
    let formatter = NSDateFormatter()
    
    
    @IBOutlet var timePickerView: UIView!
    
    @IBOutlet weak var beginTimePickerView: UIView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var beginTimeLabel: UILabel!
    
    @IBAction func setEnd(sender: AnyObject) {
        if (!timePickerView.hidden) {
            endTimeLabel.text = formatter.stringFromDate(timePicker.date)
        }
    }
    
    @IBAction func setBegin(sender: AnyObject) {
        if (!beginTimePickerView.hidden) {
            beginTimeLabel.text = formatter.stringFromDate(beginTimePicker.date)
        }
    }
    
    
    @IBAction func toggleTimePicker(sender: AnyObject) {
        timePickerView.hidden = !timePickerView.hidden
    }
    
    @IBAction func toggleBeginTimePicker(sender: AnyObject) {
        beginTimePickerView.hidden = !beginTimePickerView.hidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.timeStyle = .ShortStyle
        timePickerView.hidden = true
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushSession(sender: AnyObject) {
        var session = ["Begin Time": beginTimeLabel.text, "Details": details.text, "End Time": endTimeLabel.text, "Location": location.text, "Session Name": sessionName.text]
        
        
        var sessionsRef = ref.childByAppendingPath("Sessions/\(sessionName.text)")
        sessionsRef.setValue(session)
        
        //self.performSegueWithIdentifier("showSessions", sender: self)
    }
//
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "showSessions") {
//            let nvc : UINavigationController = segue.destinationViewController as! UINavigationController
//            let svc : SessionViewController = nvc.viewControllers[0] as! SessionViewController
//            println(self.sessionsArray)
//            svc.sessionsArray = self.sessionsArray
//        }
//    }
    
    func getSessions(completionBlock: [Session] -> Void) { //grabs existing sessions from firebase
        
        //self.sessionsArray = []
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
