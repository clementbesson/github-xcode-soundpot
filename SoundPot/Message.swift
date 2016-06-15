//
//  Message.swift
//  SoundPot
//
//  Created by Clement Besson on 6/14/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import Parse

struct Message {
    var numberOfNewMessage: Int
    // MARK: Initialization
    init?(numberOfNewMessage: Int) {
        // Initialize stored properties.
        self.numberOfNewMessage = numberOfNewMessage
    }
}
