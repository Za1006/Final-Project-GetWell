//
//  ViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/20/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource
{

    var TutorialViewController: UIPageViewController!
    var pageTitles = String()
    var pageImage = String()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 1
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    func viewControllerAtIndex(index: Int) -> ContentViewController
    {
        if ((self.pageTitles = 0) || (index >= self.pageTitles.count))
        {
            return ContentViewController()
        }
        let vc : ContentViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as? ContentViewController)!
        vc.imageFile = self.pageImage
        vc.titleText = self.pageTitles
        vc.pageIndex = index
        
        return vc
    }
//    MARK: - Page View Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as? ContentViewController
        var index = vc!.pageIndex as Int
        
        if ((index == 0) || index == NSNotFound)
        {
            return nil
        }
        
        index--
        return self.TutorialViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as? ContentViewController
        var index = vc!.pageIndex as Int
        
        if index == NSNotFound
        {
            return nil
        }
        
        index--
        if index == self.pageTitles.count
        {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func startSession(sender: AnyObject)
    {
        
    }

}
