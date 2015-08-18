//
//  CreateUserViewController.swift
//  SwiftChat
//
//  Created by Arjun Nayak on 8/8/15.
//  Copyright (c) 2015 Arjun Nayak. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class CreateUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ref = Firebase(url: "https://impromptedu.firebaseio.com")
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var biography: UITextField!
    
    @IBOutlet weak var addClassTextField: UITextField!
    var currentClasses : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addClassButton(sender: AnyObject) {
        self.currentClasses.append(addClassTextField.text)
        tableView.reloadData()
        addClassTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel!.text = currentClasses[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentClasses.count
    }
    
    @IBAction func pushSession(sender: AnyObject) {
        var user = ["Name": name.text, "Email": email.text, "Password": password.text, "Major": major.text, "Biography": biography.text, "Current Courses": currentClasses]
        
        
        var usersRef = ref.childByAppendingPath("Users/\(name.text)")
        usersRef.setValue(user)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
