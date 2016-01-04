//
//  PlaylistTableViewController.swift
//  FinalGetWell2
//
//  Created by Michael Reynolds on 1/4/16.
//  Copyright © 2016 Keron. All rights reserved.
//

import UIKit

class PlaylistTableViewController: UITableViewController
{
    
    var songs = Array<Song>()
    var parent: MediaPlayerViewController?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadSongs()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return songs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistModalViewCell", forIndexPath: indexPath)

        let aSong = songs[indexPath.row]
        cell.textLabel?.text = aSong.title
        cell.detailTextLabel?.text = aSong.artist
        
        return cell
    }
    
    override func tableView(tableview: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableview.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedSong = songs[indexPath.row]
        parent?.song = selectedSong
        parent?.loadCurrentSong()
        parent?.togglePlayback(true)
    
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismissPressed(sender: UIButton!)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    
//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return false
//    }
//
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    
//    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
//    {
//
//    }
//    
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Private Functions
    
    private func loadSongs()
    {
        do
        {
            let filePath = NSBundle.mainBundle().pathForResource("Songs", ofType: "json")
            let dataFromFile = NSData(contentsOfFile: filePath!)
            let songData: NSArray! = try NSJSONSerialization.JSONObjectWithData(dataFromFile!, options: []) as! [NSDictionary]
            for songDictionary in songData
            {
//                let aSong = Song(songDictionary: songDictionary as! NSDictionary)
                let song = Song(dictionary: songDictionary as! NSDictionary)
                
                songs.append(song)
            }
            songs.sortInPlace({ $0.title < $1.title})
//            songs.sortInPlace({ $0.artist < $1.artist})

        }
        catch let error as NSError
        {
            print(error)
        }
    }

}
