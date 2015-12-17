//
//  MainViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/17/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import UIKit

@objc protocol DatePickerDelegate
{
    func dateWasChosen(date: NSDate)
}

@objc protocol StepsListViewDelegate
{
    func stepsChecked(buttonTapped: Int)
}

class MainViewController: UIViewController,UIPopoverPresentationControllerDelegate, DatePickerDelegate, StepsListViewDelegate
{

    
    var timer: NSTimer?
    
    @IBOutlet weak var nextMeditation: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var image: UIImage!
    @IBOutlet var skipToSession: UIButton!
    
    
    var remainingCharacters = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
//        if segue.identifier == "ShowMediaSegue"
//        {
//            let mediaPlayerVC = segue.destinationViewController as! MediaPlayerViewController
//            mediaPlayerVC.delegate = self
//        }
    
        if segue.identifier == "SetReminderSegue"
        {
            let destVC = segue.destinationViewController as! SetReminderPopOverViewController
            destVC.popoverPresentationController?.delegate = self
            destVC.delegate = self
            destVC.preferredContentSize = CGSizeMake(400.0, 216.0)
        }
    }
    
    // MARK: - UIPopoverPresentationController Delegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    // MARK: DatePicker Delegate
    
    func dateWasChosen(date: NSDate)
    {
        nextMeditation.text = dateFormat(date)
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        print(NSDate())
        print(localNotification.fireDate)
        localNotification.timeZone = NSTimeZone.localTimeZone()
        localNotification.alertBody = "Time to Relax"
        localNotification.alertAction = "Open App"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
    func dateFormat(x: NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("MMM dd yyyy HH:mm", options: 0, locale: NSLocale.currentLocale())
        let formattedTime = formatter.stringFromDate(x).uppercaseString
        
        return String(formattedTime)
    }
    
    
    func stepsChecked(buttonTapped: Int)
    {
        
    }
    
    // MARK: Steps_Check_List (TableView)



}
