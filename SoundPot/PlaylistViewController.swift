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
    var messagesMutable = NSMutableArray()
    var selectedFriend = PFObject(className: "Users")
    var song = PFObject(className: "Messages")
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    let currentUser = PFUser.currentUser()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let currentUser = PFUser.currentUser()
        if (currentUser != nil){
            let query = PFQuery(className: "Messages")
            query.whereKey("recipientsIds2", equalTo:currentUser!.objectId!)
            query.whereKey("senderId", equalTo:self.selectedFriend.objectId!)
            query.orderByAscending("createdAt")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // Query succeeded
                    self.messages = objects!
                    self.messagesMutable = NSMutableArray(array: self.messages)
                    self.tableView.reloadData()
                    self.actInd.stopAnimating()
                    self.loadingView.hidden = true
                }
                    
                else {
                    print(error)
                }
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        showActivityIndicatory(self.view)
        self.tableView.delegate = self
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let imageView = UIImageView(frame: self.tableView.frame)
        let image = UIImage(named: "background-noglow.png")!
        imageView.image = image
        self.tableView.addSubview(imageView)
        self.tableView.sendSubviewToBack(imageView)
    }
    
    // MARK: - Table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesMutable.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let message = self.messagesMutable.objectAtIndex(indexPath.row)
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.messagesMutable.removeObjectAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.reloadData()
            //remove user from recipients list on the back-end
            self.song = self.messagesMutable.objectAtIndex(indexPath.row) as! PFObject
            let recipientIds = self.song.objectForKey("recipientsIds2")
            if recipientIds!.count == 1 {
                self.song.deleteInBackground()
            }
            else {
                recipientIds?.removeObject(self.currentUser?.objectId)
                self.song.setObject(recipientIds!, forKey: "recipientsIds2")
                self.song.saveInBackground()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.song = self.messagesMutable.objectAtIndex(indexPath.row) as! PFObject
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
