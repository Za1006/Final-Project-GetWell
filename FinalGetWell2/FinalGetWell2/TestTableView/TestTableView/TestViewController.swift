//
//  ViewController.swift
//  TestTableView
//
//  Created by Elizabeth Yeh on 12/18/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    
        @IBOutlet weak var checkbox: UIButton!
        @IBOutlet weak var toDoLabel: UILabel!
    
    var toDos = ["Find your meditation spot", "Get comfortable", "Clear your mind"]
    var isDone: Bool
    let checkImg = UIImage(named: "checked.png")
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return toDos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
    let cell = tableView.dequeueReusableCellWithIdentifier("ToDoCell", forIndexPath: indexPath) as! ToDoCell
    
      let aTodo = toDos[indexPath.row]
    if aTodo.isDone
    {
        
    }

    return cell

   }



}

