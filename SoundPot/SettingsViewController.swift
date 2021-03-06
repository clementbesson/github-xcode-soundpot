//
//  SettingsViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit
import Parse
import MediaPlayer


class SettingsViewController: UIViewController {

    // MARK: Properties
    @IBAction func logoutButton(sender: UIButton) {
        PFUser.logOut()
        PFInstallation.currentInstallation().removeObjectForKey("userId")
        PFInstallation.currentInstallation().saveInBackground()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
}