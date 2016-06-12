//
//  SendViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import Parse
import UIKit
import MediaPlayer

class SendViewController: UITableViewController {

    
    // MARK: Properties
    var friendsRelation = PFRelation()
    var friends :NSArray = []
    let currentUser = PFUser.currentUser()
    var friend = PFObject(className: "Users")
    var recipients : NSMutableArray = []
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage(named: "background-noglow.png")!
        imageView.image = image
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        self.friendsRelation = (currentUser?.objectForKey("friendsRelation"))! as! PFRelation
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        showActivityIndicatory(self.view)
        let currentUser = PFUser.currentUser()
        if (currentUser != nil){
            // Get messages from server
            var query = PFQuery(className: "User")
            query = self.friendsRelation.query()
            query.orderByAscending("username")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    self.friends = objects!
                    self.tableView.reloadData()
                    self.actInd.stopAnimating()
                    self.loadingView.hidden = true
                }
                else {
                    print(error)
                }
            }
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("login")
            self.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    // MARK: - Table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let message = self.friends.objectAtIndex(indexPath.row)
        let friendName = message.objectForKey("username")
        print(friendName)
        cell.textLabel?.text = String(friendName!)
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        else {
            cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let recipient = self.friends.objectAtIndex(indexPath.row)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                self.recipients.removeObject(recipient.objectId!!)
                cell.accessoryType = .None
            } else {
                self.recipients.addObject(recipient.objectId!!)
                cell.accessoryType = .Checkmark
            }
            
        }
    }
    
    // MARK: - Export Function
    func sendToParse(track: NSString, artist:NSString, album:NSString, artwork:MPMediaItemArtwork, songURL:NSURL) -> Void {
        let artworkImageContent :UIImage
        artworkImageContent = artwork.imageWithSize(CGSizeMake(300, 300))!
        
        let artworkData = NSData(data: UIImagePNGRepresentation(artworkImageContent)!)
        let audioData = NSData(contentsOfURL: songURL)
        let imageFile = PFFile(name: "image.png", data: artworkData)
        let soundFile = PFFile(name: "song.m4a", data: audioData!)
        let message = PFObject(className: "Messages")
        
        message["file"] = soundFile
        message["filetype"] = "music.mp3"
        message["artwork"] = imageFile
        message.setObject(track, forKey: "track")
        message.setObject(artist, forKey: "artist")
        message.setObject(album, forKey: "album")
        message.setObject(self.recipients, forKey: "recipientsIds")
        message.setObject(self.recipients, forKey: "recipientsIds2")
        message.setObject((self.currentUser?.objectId)!, forKey: "senderId")
        message.setObject((self.currentUser?.username)!, forKey: "userName")
        message.saveInBackgroundWithBlock { (succeded : Bool, error : NSError?) in
            if succeded {
                // Sends a notification to recipients
                let pushQuery = PFInstallation.query()!
                pushQuery.whereKey("userId", containedIn: self.recipients as [AnyObject])
                let push = PFPush()
                push.setQuery(pushQuery)
                push.setMessage("New track from \(PFUser.currentUser()!.username!)!")
                push.sendPushInBackground()
            }
            else{
                // show alert if not song being played
                let sendAlert = UIAlertController(title: "Network Error...", message: "We could not send your track :(", preferredStyle: UIAlertControllerStyle.Alert)
                sendAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.performSegueWithIdentifier("SendToHome", sender: self)
            }
        }
        self.actInd.stopAnimating()
        self.loadingView.hidden = true
        self.performSegueWithIdentifier("SendToHome", sender: self)
    }
    
    @IBAction func sendButton(sender: UIBarButtonItem) {
        self.loadingView.hidden = false
        showActivityIndicatory(self.view)
        let instanceOfUploadObject: UploadLibrary = UploadLibrary()
        instanceOfUploadObject.getTrackData()
        // get song metadata
        let artwork = instanceOfUploadObject.artwork
        let track = instanceOfUploadObject.trackValue
        let artist = instanceOfUploadObject.artistValue
        let album = instanceOfUploadObject.albumValue
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            let songURL = instanceOfUploadObject.audioURL
            self.sendToParse(track, artist: artist, album: album, artwork: artwork, songURL: songURL)
            
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

    }
    
    // MARK - UI
    func showActivityIndicatory(uiView: UIView) {
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = self.view.center
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
    }}

