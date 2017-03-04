//
//  Score.swift
//  MarbleShooter
//
//  Created by Sam Knepper on 11/8/16.
//  Copyright © 2016 Apress. All rights reserved.
//

import Foundation
import Firebase

struct Score {

    //var username: String?
    //var scoreVal: Int?
    
    
    let key: String
    let scoreVal: Int
    let username: String
    let ref: FIRDatabaseReference?
    
    init(scoreVal: Int, username: String, key: String = "") {
        self.key = key
        self.scoreVal = scoreVal
        self.username = username
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        scoreVal = snapshotValue["scoreVal"] as! Int
        username = snapshotValue["username"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "scoreVal": scoreVal,
            "username": username
        ]
    }
    
}
