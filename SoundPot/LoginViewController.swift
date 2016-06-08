//
//  LoginViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/7/16.
//  Copyright (c) 2016 Clement Besson. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate{
    // MARK: Properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        usernameTextField.delegate = self
        // The self refers to the ViewController class, because it’s referenced inside the scope of the LoginViewController class definition.
        
        // LoginViewController is now a delegate for usernameTextField.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {

    }
    
    // MARK: Actions
    @IBAction func loginButton(sender: UIButton) {
        print("button")
        let user = User(username: usernameTextField.text!, password: passwordTextField.text!)
        
        if user?.username == "" || user?.password == "" {
            // show alert if invalid credentials
            let loginalert = UIAlertController(title: "Invalid Credentials", message: "Please enter a username and password!", preferredStyle: UIAlertControllerStyle.Alert)
            loginalert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(loginalert, animated: true, completion: nil)
        }
        
        else{
            // if valid credentials connects to Parse
            PFUser.logInWithUsernameInBackground((user?.username)!, password: (user?.password)!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Successful login
                    print("all good")
                    var currentUser = PFUser.currentUser()
                    while currentUser == nil {
                        // Fetch Data
                        currentUser = PFUser.currentUser()
                    }
                    print(currentUser?.username)
                    self.performSegueWithIdentifier("LoginToHome", sender: nil)
                    
                } else {
                    // The login failed. Check error to see why.
                }
            }
            
        }

    }
    
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
