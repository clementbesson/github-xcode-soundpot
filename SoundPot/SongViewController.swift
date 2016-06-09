//
//  SongViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit
import Parse
import MediaPlayer
import AVFoundation

class SongViewController: UIViewController {
    // MARK: Properties
    var messages = NSArray()
    var selectedSong = PFObject(className: "Messages")
    var audioPlayer =  AVAudioPlayer()
    var currentUser = PFUser.currentUser()
    
    @IBOutlet weak var trackLabel: UITextView!
    @IBOutlet weak var artistLabel: UITextView!
    @IBOutlet weak var albumLabel: UITextView!
    @IBOutlet weak var coverView: UIImageView!
    @IBAction func playButton(sender: UIButton) {
        
        //audioPlayer.prepareToPlay()
        let songData = self.selectedSong.objectForKey("file")
        let song = songData as! PFFile
        let songURL = NSURL(string: song.url!)
        let data = NSData(contentsOfURL: songURL!)
        //var error:NSError?
        do{
           audioPlayer = try AVAudioPlayer(data: data!)
        }
        catch{
            print("Error with Player")
        }
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        audioPlayer.play()
        print(songURL)
        
        //remove user from recipients list
        
        let recipientIds = self.selectedSong.objectForKey("recipientsIds")
        print("old recipients")
        print(recipientIds)
        recipientIds?.removeObject(self.currentUser?.objectId)
        self.selectedSong.setObject(recipientIds!, forKey: "recipientsIds")
        print("new recipients")
        print(recipientIds)
        self.selectedSong.saveInBackground()
    }

override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    trackLabel.text = String(self.selectedSong.objectForKey("track")!)
    artistLabel.text = String(self.selectedSong.objectForKey("artist")!)
    albumLabel.text = String(self.selectedSong.objectForKey("album")!)
    
    let imageData = self.selectedSong.objectForKey("artwork")
    let image = imageData as! PFFile
    let imageURL = NSURL(string: image.url!)
    let data = NSData(contentsOfURL: imageURL!)
    let cover = UIImage(data: data!)
    coverView.image =  cover
}
override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }
}