//
//  Session.swift
//  ImprompEDU
//
//  Created by Kevin Hui on 8/8/15.
//  Copyright (c) 2015 whatever. All rights reserved.
//

import Foundation

class Session {
    var beginTime : String
    var details : String
    var endTime : String
    var location : String
    var sessionName : String
    
    init(beginTime : String, details: String, endTime : String, location: String, sessionName: String) {
        self.beginTime = beginTime
        self.details = details
        self.endTime = endTime
        self.location = location
        self.sessionName = sessionName
    }
}