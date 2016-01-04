//
//  ViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/20/15.
//  Copyright © 2015 Keron. All rights reserved.
//
//
//import UIKit
//
//class ViewController: UIViewController, UIPageViewControllerDataSource
//{
//
//    var pageViewController: UIPageViewController!
//    var pageTitles = ["Welcome to GetWell"]
//    var pageImage = [""]
//    var count = 0
//    
//    var delegate: ViewController?
//    
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        self.pageTitles = ["Welcome to GetWell", "How to Start"]
//        self.pageImage = ["",""]
//        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
//        self.pageViewController.dataSource = self
//        let StartVC = self.viewControllerAtIndex(0) as ContentViewController
//        let viewControllers = NSArray(object: StartVC)
//        self.pageViewController.setViewControllers((viewControllers as! [UIViewController]), direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
//        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 60)
//        self.addChildViewController(self.pageViewController)
//        self.view.addSubview(self.pageViewController.view)
//        self.pageViewController.didMoveToParentViewController(self)
//
//
//    }
//
//    override func didReceiveMemoryWarning()
//    {
//        super.didReceiveMemoryWarning()
//    }
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
//    {
//        return pageTitles.count
//    }
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
//    {
//        return 0
//    }
//    func viewControllerAtIndex(index: Int) -> ContentViewController
//    {
//        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count))
//        {
//            return ContentViewController()
//        }
//        let contentViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as? ContentViewController)!
//        contentViewController.imageFile = self.pageImage[index]
//        contentViewController.titleText = self.pageTitles[index]
//        contentViewController.pageIndex = index
//        
//        return contentViewController
//    }
////    MARK: - Page View Controller Data Source
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
//    {
//        let vc = viewController as? ContentViewController
//        var index = vc!.pageIndex! as Int
//        
//        if ((index == 0) || index == NSNotFound)
//        {
//            return nil
//        }
//        
//        index--
//        return self.viewControllerAtIndex(index)
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
//    {
//        var index = (viewController as! ContentViewController).pageIndex!
////        var index = vc!.pageIndex! as Int
//        
//        if index == 0
//        {
//            return nil
//        }
//        
//        index++
//        
//        if index == self.pageTitles.count
//        {
//            return nil
//        }
//        return self.viewControllerAtIndex(index)
//    }
//    
//
//    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//    {
//        if segue.identifier == "StartSession"
//        {
//            let viewVC = segue.destinationViewController as! ViewController
//            viewVC.delegate = self
//        }
//        
//    }
//
// 
//    
//    @IBAction func startSession(sender: AnyObject)
//    {
//
//        self.viewControllerAtIndex(0)
//        self.viewControllerAtIndex(0) as ContentViewController
//        self.pageViewController.view .removeFromSuperview()
//
//        
//
//    }
//
//}
////
