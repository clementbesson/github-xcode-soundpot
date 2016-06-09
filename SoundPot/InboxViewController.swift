//
//  InboxViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/7/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit
import Parse
import MediaPlayer


class InboxViewController: UITableViewController {

    // MARK: Properties
    var friendsRelation = PFRelation()
    var songs :NSArray = []
    var theSong :NSArray = []
    var songId :String?! = ""
    let currentUser = PFUser.currentUser()
    var song = PFObject(className: "Messages")
    
    //var selectedTrack = NSArray =
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
        let currentUser = PFUser.currentUser()
        if (currentUser != nil){
            // Get messages from server
            let query = PFQuery(className: "Messages")
            query.whereKey("recipientsIds", equalTo:(currentUser?.objectId)!)
            query.orderByAscending("track")
            query.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        // The find succeeded.
                        self.songs = objects!
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
        //print(self.songs.count)
        return self.songs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let message = self.songs.objectAtIndex(indexPath.row)
        let trackName = message.objectForKey("track")
        cell.textLabel?.text = String(trackName!)
        cell.textLabel?.textColor = UIColor.whiteColor()
        if (indexPath.row % 2 == 0){
        cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        else {
            cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.songId = self.songs.objectAtIndex(indexPath.row).objectId
        self.song = self.songs.objectAtIndex(indexPath.row) as! PFObject
        self.performSegueWithIdentifier("inboxToSong", sender: self)
        }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //self.songId = self.songs.objectAtIndex(indexPath.row).objectId
        if (segue.identifier == "inboxToSong") {
            // pass data to next view
            let songvc = segue.destinationViewController as! SongViewController
            songvc.selectedSong = self.song
        }
    }
}

