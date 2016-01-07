//
//  StartUPViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 1/6/16.
//  Copyright © 2016 Keron. All rights reserved.
//

import UIKit

class StartUPViewController: UIViewController, UITextFieldDelegate
{

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) 
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func createAccountTapped(sender: UIBarButtonItem)
    {
        self.navigationController?.performSegueWithIdentifier("ShowRegisterSegue", sender: self)

    }
    
    @IBAction func loginUserTapped(sender: UIButton)
    {
        self.navigationController?.performSegueWithIdentifier("ShowPlaylistSegue", sender: self)

    }

    @IBAction func signinAsGuestTapped(sender: UIButton)
    {
        self.navigationController?.performSegueWithIdentifier("ShowMediaVCSegue", sender: self)

    }
}
