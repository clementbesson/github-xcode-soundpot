//
//  PlaylistViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit
import Parse
import MediaPlayer

class PlaylistViewController: UITableViewController {
    
    // MARK: Properties
    var messages = NSArray()
    var selectedFriend = PFObject(className: "Users")
    var song = PFObject(className: "Messages")
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let currentUser = PFUser.currentUser()
        if (currentUser != nil){
            let query = PFQuery(className: "Messages")
            query.whereKey("recipientsIds", equalTo:currentUser!.objectId!)
            query.whereKey("senderId", equalTo:self.selectedFriend.objectId!)
            query.orderByAscending("createdAt")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    self.messages = objects!
                    self.tableView.reloadData()
                    print("track is")
                    print(self.messages.objectAtIndex(0).objectForKey("track"))
                }
                    
                else {
                    print(error)
                }
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

    }
    
    // MARK: - Table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let message = self.messages.objectAtIndex(indexPath.row)
        let songName = message.objectForKey("track")
        cell.textLabel?.text = String(songName!)
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        else {
            cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.song = self.messages.objectAtIndex(indexPath.row) as! PFObject
        self.performSegueWithIdentifier("PlaylistToSong", sender: self)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "PlaylistToSong") {
            // pass data to next view
            let songvc = segue.destinationViewController as! HistorySongViewController
            songvc.selectedSong = self.song
        }
    }
}
