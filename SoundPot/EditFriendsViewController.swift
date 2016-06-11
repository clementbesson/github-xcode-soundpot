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
        self.friendsRelation = (self.currentUser?.relationForKey("friendsRelation"))!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if (currentUser != nil){
            // Get messages from server
            showActivityIndicatory(self.view)
            var query: PFQuery = PFUser.query()!
            query.orderByAscending("username")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    self.users = objects!
                    self.tableView.reloadData()
                    self.actInd.stopAnimating()
                    self.loadingView.hidden = true
                }
                    
                else {
                    print(error)
                }
            }

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
        let user: PFUser = self.users.objectAtIndex(indexPath.row) as! PFUser
        let rel = currentUser?.relationForKey("friendsRelation")
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                rel!.removeObject(user)
                cell.accessoryType = .None
            } else {
                rel!.addObject(user)
                cell.accessoryType = .Checkmark
            }
        }
    }
    
    @IBAction func saveBarButton(sender: UIBarButtonItem) {
        self.actInd.startAnimating()
        self.loadingView.hidden = false
        currentUser!.saveInBackgroundWithBlock({ (succeded: Bool, error: NSError?) in
            if succeded {
                self.actInd.stopAnimating()
                self.loadingView.hidden = true
                self.performSegueWithIdentifier("SaveToSettings", sender: self)
            }
        })
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    }
    
    // MARK - Friend Test
    func isFriende(user: PFUser) -> Bool {
        var testValue = false
        for parseUser in self.friends {
            if user.objectId == parseUser.objectId {
                testValue = true
                break
            }
            else {
                testValue = false
            }
        }
        return testValue
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
    }
}
