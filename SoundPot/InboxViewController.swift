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
    var friends :NSArray = []
    //var selectedSender : PFObject
    let currentUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.friendsRelation = (currentUser?.objectForKey("friendsRelation"))! as! PFRelation
        print(friendsRelation)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let currentUser = PFUser.currentUser()
        if (currentUser != nil){
            // Get messages from server
            var query = PFQuery(className: "Messages")
            query.whereKey("recipientsIds", equalTo:(currentUser?.objectId)!)
            query.orderByAscending("userName")
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
        print(self.friends.count)
        return self.friends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let message = self.friends.objectAtIndex(indexPath.row)
        let senderName = message.objectForKey("userName")
        print(senderName)
        cell.textLabel?.text = String(senderName!)
        if (indexPath.row % 2 == 0){
        cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        else {
            cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedSender: PFObject = self.friends.objectAtIndex(indexPath.row) as! PFObject
        print(selectedSender.objectId)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "inboxToPlaylist") {
            // pass data to next view
        }
    }
}

