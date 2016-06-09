//
//  EditFriendsViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit
import Parse
import MediaPlayer

class EditFriendsViewController: UITableViewController {

    
    // MARK: Properties
    var friendsRelation = PFRelation()
    var allUser = PFUser()
    
    var users :NSArray = []
    var friends : NSArray = []
    let currentUser = PFUser.currentUser()
    var friend = PFObject(className: "Users")
    
    //var selectedTrack = NSArray =
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let imageView = UIImageView(frame: self.view.frame)
        //let frame = CGRect(x: 0, y: 0 , width: self.fra, height: <#T##CGFloat#>)
        //let imageView = UIImageView(frame: <#T##CGRect#>)
        
        //let image = UIImage(named: "background-noglow.png")!
        let image = UIImage(named: "background-noglow.png")!
        imageView.image = image
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        self.friendsRelation = (currentUser?.objectForKey("friendsRelation"))! as! PFRelation
        //self.friends = self.friendsRelation
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if (currentUser != nil){
            // Get messages from server
            var query: PFQuery = PFUser.query()!
            
            //query = self.allUser.query()
            query.orderByAscending("username")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    self.users = objects!
                    self.tableView.reloadData()
                }
                    
                else {
                    print(error)
                }
            }
            
            
          
            //var friendQuery = PFQuery(className: "User")
            query = PFQuery(className: "User")
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
        return self.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let user = self.users.objectAtIndex(indexPath.row)
        let userName = user.objectForKey("username")
        cell.textLabel?.text = String(userName!)

        let test = self.isFriende(user as! PFUser)
        
        if (test == true){
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        else {
            cell.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        }
        

        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let user = self.users.objectAtIndex(indexPath.row)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                //friendsRelation.removeObject(user as! PFObject)
            } else {
                cell.accessoryType = .Checkmark
                //friendsRelation.addObject(user as! PFObject)
            }
        }
       // currentUser?.saveInBackgroundWithBlock({(succeded, error) in
            //if (error != nil) {
            //    print(error)
          //  }
        //})
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
    }
    
    // MARK - Friend Test
    func isFriende(user: PFUser) -> Bool {
        var testValue = false
        for parseUser in self.friends {
            if user.objectId == parseUser.objectId {
                print("is friend")
                testValue = true
                break
            }
            else {
                print ("is not friend")
                testValue = false
            }
        }
        return testValue
    }
}
