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
    
    @IBAction func sendButton(sender: UIBarButtonItem) {
        let instanceOfCustomObject: UploadLibrary = UploadLibrary()
        instanceOfCustomObject.someProperty = "Hello World"
        instanceOfCustomObject.someMethod()
        
       // let audioURL =
        let artwork = instanceOfCustomObject.artwork
        let track = instanceOfCustomObject.trackValue
        let artist = instanceOfCustomObject.artistValue
        let album = instanceOfCustomObject.albumValue
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            let songURL = instanceOfCustomObject.audioURL
            self.sendToParse(track, artist: artist, album: album, artwork: instanceOfCustomObject.artwork, songURL: songURL)
        }
        //let artworkImage.image = artworkImageContent
   
    }
    
    //var selectedTrack = NSArray =
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        //self.navigationController.view.backgroundColor = UIColor(white: 0, alpha: 0)
        self.friendsRelation = (currentUser?.objectForKey("friendsRelation"))! as! PFRelation
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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
        print(recipients)
    }
    
    // MARK: - Export Function
    
    
    func sendToParse(track: NSString, artist:NSString, album:NSString, artwork:MPMediaItemArtwork, songURL:NSURL) -> Void {
        
        print(track)
        print(artist)
        print(album)
        print(songURL)
        
        //var artworkData: NSData
        //var audioData: NSData
        
        let artworkImageContent :UIImage
        artworkImageContent = artwork.imageWithSize(CGSizeMake(300, 300))!
        //artworkData = UIImagePNGRepresentation(artworkImageContent)
        
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
                print("success")
            }
            else{
                print(error)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "HistoryToPlaylist") {

            
            
        }
    }
}
