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

class MainViewController: UIViewController,UIPopoverPresentationControllerDelegate, DatePickerDelegate, UITableViewDataSource, UITableViewDelegate
    
{

    
    var timer: NSTimer?
    
    @IBOutlet weak var nextMeditation: UILabel!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var image: UIImage!
    @IBOutlet var skipToMedia: UIButton!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var next: UIButton!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var setReminderButton: UIBarButtonItem!
    
    var allToDos = ["Find your meditation spot", "Get comfortable", "Begin Deep Breathing", "Clear your mind"]
    var shownTodos = [String]()
    var currentItemIndex = 0
    
    var isDone: Bool?
    let checkImg = UIImage(named: "checked.png")
    let uncheckImg = UIImage(named: "unchecked.png")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        next.hidden = true
        next.alpha = 0
        isDone = false

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return shownTodos.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("aCell", forIndexPath: indexPath) as! TableViewCell
        
        let todo = shownTodos[indexPath.row]
        
        cell.todoDescription.text = todo
        
        switch cell.isDone
            
        {
            
        case true: cell.todoCheckbox.image = UIImage(named: "checked.png")
            
        case false: cell.todoCheckbox.image = UIImage(named: "unchecked.png")
            
        }
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.visibleCells[indexPath.row] as! TableViewCell
        
        cell.isDone = !cell.isDone
        enableNextButtonWithAnimation()
        
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(sender: UIButton!)
        
    {
        isDone = true
        let newTodo = allToDos[currentItemIndex]
        shownTodos.insert(newTodo, atIndex: currentItemIndex)
     
        let newItemIndexPath = NSIndexPath(forRow: currentItemIndex, inSection: 0)
        tv.insertRowsAtIndexPaths([newItemIndexPath], withRowAnimation: .Automatic)
        
        currentItemIndex += 1
        if currentItemIndex == 4
            
        {
            sender.enabled = false
        }
        
    }
    
    
    func enableNextButtonWithAnimation()
        
    {
        var count = 0
        let visibleCells = tv.visibleCells as! [TableViewCell]
        for cell in visibleCells
        {
            if cell.isDone
                
            {
                count++
            }
            
        }
        
        if count == 4
            
        {
            next.hidden = false
            let originalNextButtonY = next.frame.origin.y
            next.frame.origin.y += next.frame.size.height
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.next.alpha = 1
                
                self.next.frame.origin.y = originalNextButtonY
                
                }) { (_) -> Void in
                    
                    //nothing
            }
        }
            
        else  if next.hidden == false || next.alpha != 0
            
        {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.next.alpha = 0
                
                }, completion: { (_) -> Void in
                    
                    self.next.hidden = true
            })
        }
    }
    
    
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowMediaSegue"
        {
            let mediaPlayerVC = segue.destinationViewController as! MediaPlayerViewController
            mediaPlayerVC.delegate = self
        }
        
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
        nextMeditation.text = "Next session: \(dateFormat(date))"
        
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
    



}
