//
//  LoginViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/17/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func userCanSignIn() -> Bool
    {
        if usernameTextField.text != "" && passwordTextField.text != ""
        {
            return true
        }
        return false
    }
    

    @IBAction func signInTapped(sender: UIButton)
    {
        if userCanSignIn()
        {
            PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil
                {
                    print("login successful")
                    self.performSegueWithIdentifier("ShowLoginSegue", sender: self)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else
                {
                    print(error?.localizedDescription)
                    self.errorMessageLabel.text = "Please enter username and password to login."
                }
            }
        }
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
