//
//  SessionTableViewCell.swift
//  ImprompEDU
//
//  Created by Kevin Hui on 8/8/15.
//  Copyright (c) 2015 whatever. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var numMembers: UILabel!
    @IBOutlet weak var host: UILabel!
    @IBOutlet weak var beginTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    
    var session : Session? {
        didSet {
            if let sesh = session {
                self.className.text = sesh.sessionName
                //self.host.text = "Kevin"
                //self.numMembers.text
                //self.host
                //self.beginTime.text = sesh.beginTime
                //self.endTime.text = sesh.endTime
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
