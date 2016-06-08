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
    var id : String?! = ""//PFObject(className: "Messages")
    var messages = NSArray()
    var selectedSong = PFObject(className: "Messages")
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print(self.selectedSong.objectForKey("artist"))
        print(self.selectedSong.objectForKey("track"))
        print(self.selectedSong.objectForKey("album"))
        /*print("id is")
        print(self.id?!)
        let currentUser = PFUser.currentUser()
        if (currentUser != nil){
            let query = PFQuery(className: "Messages")
            query.whereKey("objectId", equalTo:String(self.id!))
            //query.whereKey("userName", equalTo:self.sender.objectForKey("userName")!)
            //query.orderByAscending("CreatedAt")
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
        }*/

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        let currentUser = PFUser.currentUser()
        if (currentUser != nil){
        let query = PFQuery(className: "Messages")
        query.whereKey("objectId", equalTo:String(self.id))
        //query.whereKey("userName", equalTo:self.sender.objectForKey("userName")!)
        //query.orderByAscending("CreatedAt")
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
    
    // MARK: - Table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        //Configure the cell
        let song = self.messages.objectAtIndex(indexPath.row)
        cell.textLabel?.text = String(song.objectForKey("track"))
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
        self.selectedSong = self.messages.objectAtIndex(indexPath.row) as! PFObject
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
            
        
    }
    
}
