//
//  LoginViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/7/16.
//  Copyright (c) 2016 Clement Besson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    // MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    //var username = ""
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
        var user = User(username: usernameTextField.text!, password: passwordTextField.text!)

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
