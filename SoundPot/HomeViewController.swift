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
var timer: NSTimer!

class HomeViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var track: UITextView!
    @IBOutlet weak var album: UITextView!
    @IBOutlet weak var artist: UITextView!
    @IBOutlet weak var inbox: UILabel!
    @IBAction func inboxButton(sender: UIButton) {
        timer.invalidate()
    }

    @IBAction func historyButton(sender: UIButton) {
        timer.invalidate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let query = PFQuery(className: "Messages")
        let currentUser = PFUser.currentUser()
        if (currentUser != nil) {
            query.whereKey("recipientsIds", equalTo:(currentUser?.objectId)!)
            query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages.")
                // Do something with the found objects
                self.inbox.text = String( objects!.count)
                print(String( objects!.count))
                
                timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(self.updateNowPlayingInfo), userInfo: nil, repeats: true)
                self.updateNowPlayingInfo()
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        // check is user is cached and goes to the login page otherwise
        let currentUser = PFUser.currentUser()
        print(currentUser?.username)
        if (currentUser != nil) {
            print(currentUser!.username)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("login")
            self.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    
    
    // Gets iOS device player information
    func updateNowPlayingInfo(){
        let player = MPMusicPlayerController.applicationMusicPlayer()
        var currentItem: MPMediaItem
        // if somthing is being played
        if (player.nowPlayingItem != nil){
            currentItem = player.nowPlayingItem!
            let current_title = currentItem.valueForProperty(MPMediaItemPropertyTitle)?.string
            let current_artist = currentItem.valueForProperty(MPMediaItemPropertyArtist)?.string
            let current_album = currentItem.valueForProperty(MPMediaItemPropertyAlbumTitle)?.string
            let current_artwork = currentItem.valueForProperty(MPMediaItemPropertyArtwork)?.imageWithSize(CGSizeMake(300, 300))
            self.track.text = current_title
            self.artist.text = current_artist
            self.album.text = current_album
            self.artworkImage.image = current_artwork
        }
        // Otherwise does not get player info
        else{
            print("no song played")
            return
        }
    }
}


