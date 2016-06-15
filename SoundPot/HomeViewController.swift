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
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    var logoView: UIView = UIView()
    var logoImage: UIImageView = UIImageView()
    var timer: NSTimer!
    
    @IBAction func inboxButton(sender: UIButton) {
        timer.invalidate()
    }
    
    @IBAction func historyButton(sender: UIButton) {
        timer.invalidate()
    }
    @IBAction func settingsButton(sender: UIButton) {
        timer.invalidate()
    }
    @IBAction func sendButton(sender: AnyObject) {
        timer.invalidate()
        let instanceOfTrackObject: TrackingInfoLibrary = TrackingInfoLibrary()
        instanceOfTrackObject.getNowPlayingInfo()
        if (instanceOfTrackObject.albumValue != "No song currently played..."){
            self.performSegueWithIdentifier("HomeToSend", sender: self)
        }
        else {
            // show alert if not song being played
            let loginalert = UIAlertController(title: "Music Off :(", message: "You need to listen to a song!", preferredStyle: UIAlertControllerStyle.Alert)
            loginalert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(loginalert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImage.frame = CGRectMake(0, 0, 120, 120)
        logoImage.center = self.view.center
        logoImage.image = UIImage(named: "logo-soundpot-2.png")
        logoImage.backgroundColor = UIColor.blackColor()
        logoImage.clipsToBounds = true
        logoImage.layer.cornerRadius = 10
        logoImage.hidden = true
        self.view.addSubview(logoImage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        updateNowPlayingInfo()
        showActivityIndicatory(self.view)
        getParseData()
        
    }
    
    func getParseData() {
        let query = PFQuery(className: "Messages")
        let currentUser = PFUser.currentUser()
        if (currentUser != nil) {
            query.whereKey("recipientsIds", equalTo:(currentUser?.objectId)!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // Do something with the found objects
                    self.inbox.text = String(objects!.count)
                    UIApplication.sharedApplication().applicationIconBadgeNumber = (objects?.count)!
                    if self.timer == nil{
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(self.updateNowPlayingInfo), userInfo: nil, repeats: true)
                    }
                    self.actInd.stopAnimating()
                    self.loadingView.hidden = true
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
        if (currentUser == nil) {
            let storyboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("login")
            self.presentViewController(vc, animated: false, completion: nil)
        }
 
    }
    
    // Gets iOS device player information
    func updateNowPlayingInfo(){
        // if somthing is being played
        let music: TrackingInfoLibrary = TrackingInfoLibrary()
        music.getNowPlayingInfo()
        self.artworkImage.image = nil
        self.track.text = music.trackValue
        self.artist.text = music.artistValue
        self.album.text = music.albumValue
        
        if (music.albumValue != "No song currently played..."){
            let music: TrackingInfoLibrary = TrackingInfoLibrary()
            music.getNowPlayingInfo()
            let artworkImageContent :UIImage?
            artworkImageContent = music.artwork.imageWithSize(CGSizeMake(300, 300))!
            self.artworkImage.image = artworkImageContent
            self.logoImage.hidden = true
        }
        else {
            showLogo(self.logoImage)
        }
    }
    
    // MARK - UI
    func showActivityIndicatory(uiView: UIView) {
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
                                    loadingView.frame.size.height / 2);
        actInd.hidesWhenStopped = true
        loadingView.addSubview(actInd)
        uiView.addSubview(loadingView)
        actInd.startAnimating()
    }
    
    func showLogo(uiView: UIView) {
        uiView.hidden = false
    }
    
    // MARK - Notification

    
}


