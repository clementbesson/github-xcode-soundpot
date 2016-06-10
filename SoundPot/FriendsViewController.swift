//
//  FriendsViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit
import Parse
import MediaPlayer

class FriendsViewController: UITableViewController {
    
    
    // MARK: Properties
    var friendsRelation = PFRelation()
    var friends :NSArray = []
    let currentUser = PFUser.currentUser()
    var friend = PFObject(className: "Users")
    
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
            var query = PFQuery(className: "User")
            query = self.friendsRelation.query()
            query.orderByAscending("username")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]!?, error: NSError?) -> Void in
                
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
        let friend = self.friends.objectAtIndex(indexPath.row)
        let friendName = friend.objectForKey("username")
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

    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

    }
}


