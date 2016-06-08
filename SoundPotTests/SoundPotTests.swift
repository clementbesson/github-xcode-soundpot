//
//  SoundPotTests.swift
//  SoundPotTests
//
//  Created by Clement Besson on 6/7/16.
//  Copyright (c) 2016 Clement Besson. All rights reserved.
//

import UIKit
import XCTest

class SoundPotTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK SoundPor Tests
    
    func testUserInitialization (){
        // Success case.
        let potentialUser = User(username: "Clem", password: "")
        XCTAssertNotNil(potentialUser)
    }
}
