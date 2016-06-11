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
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    
    @IBOutlet weak var trackLabel: UITextView!
    @IBOutlet weak var artistLabel: UITextView!
    @IBOutlet weak var albumLabel: UITextView!
    @IBOutlet weak var coverView: UIImageView!
    
    @IBAction func playButton(sender: UIButton) {
        let songData = self.selectedSong.objectForKey("file")
        let song = songData as! PFFile
        let songURL = NSURL(string: song.url!)
        let data = NSData(contentsOfURL: songURL!)

        do{
           audioPlayer = try AVAudioPlayer(data: data!)
        }
        catch{
            print("Error with Player")
        }
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        audioPlayer.play()
        
        //remove user from recipients list on the back-end
        let recipientIds = self.selectedSong.objectForKey("recipientsIds")
        recipientIds?.removeObject(self.currentUser?.objectId)
        self.selectedSong.setObject(recipientIds!, forKey: "recipientsIds")
        self.selectedSong.saveInBackground()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print("start the view")
        showActivityIndicatory(self.view)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
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
    self.actInd.stopAnimating()
    self.loadingView.hidden = true
}
    
    // MARK - UI
    func showActivityIndicatory(uiView: UIView) {
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
                                    loadingView.frame.size.height / 2);
        actInd.hidesWhenStopped = true
        loadingView.addSubview(actInd)
        uiView.addSubview(loadingView)
        actInd.startAnimating()
    }
}