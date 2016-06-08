//
//  User.swift
//  SoundPot
//
//  Created by Clement Besson on 6/7/16.
//  Copyright (c) 2016 Clement Besson. All rights reserved.
//

//import UIKit

class User {
    // MARK: Properties
    var username: String = ""
    var password: String = ""
    
    // MARK: Initialization
    init?(username: String, password: String) {
        // Initialize stored properties.
        self.username = username
        self.password = password
        
        // Initialization should fail if there is no username nor password
        //if username == "" || password.isEmpty {
          //  return nil
        //}
    }
}


