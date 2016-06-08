//
//  HomeViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/7/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import Parse
import UIKit
import MediaPlayer

class HomeViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var track: UITextView!
    @IBOutlet weak var album: UITextView!
    @IBOutlet weak var artist: UITextView!
    @IBOutlet weak var inbox: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var query = PFQuery(className: "Messages")
        let currentUser = PFUser.currentUser()
   
        query.whereKey("recipientsIds", equalTo:(currentUser?.objectId)!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages.")
                // Do something with the found objects
                self.inbox.text = String( objects!.count)
                print(String( objects!.count))
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let currentUser = PFUser.currentUser()
        print(currentUser?.username)
        if (currentUser != nil) {
            print(currentUser!.username)
        }
        else {
            self.performSegueWithIdentifier("HomeToLogin", sender: nil)
        }
    }
}
