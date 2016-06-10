//
//  SignUpViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/9/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // Mark: Actions
    @IBAction func signUpButton(sender: UIButton) {
        let user = User(username: usernameTextField.text!, password: passwordTextField.text!, email: emailTextField.text!)
        
        if user?.username == "" || user?.password == "" || user?.email == ""{
            // show alert if invalid credentials
            let loginalert = UIAlertController(title: "Missing Field", message: "Please enter a username, password and email address!", preferredStyle: UIAlertControllerStyle.Alert)
            loginalert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        }
            
        else{
            // if valid credentials connects to Parse
        
            let newUser = PFUser()
            newUser.username = user?.username
            newUser.password = user?.password
            newUser.email = user?.email
    
            newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                if (error != nil ){
                    let loginalert = UIAlertController(title: "Network error :(", message: "verify your connection and try again", preferredStyle: UIAlertControllerStyle.Alert)
                    loginalert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                }
                else {
                    PFInstallation.currentInstallation().setObject(newUser.objectId!, forKey: "userId")
                    PFInstallation.currentInstallation().saveInBackground()
                    self.performSegueWithIdentifier("SignupToHome", sender: self)
                }
            })
            
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        // The self refers to the ViewController class, because it’s referenced inside the scope of the LoginViewController class definition.
        
        // LoginViewController is now a delegate for usernameTextField.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
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