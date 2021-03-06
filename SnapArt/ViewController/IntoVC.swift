//
//  IntoVC.swift
//  FrameBridgeLike
//
//  Created by HD on 10/3/15.
//  Copyright (c) 2015 Duc Ngo Hoai. All rights reserved.
//

import UIKit
import SwiftyJSON

class IntoVC: CustomViewController,UIPageViewControllerDataSource, UIAlertViewDelegate ,UIPageViewControllerDelegate {
    var vcArray:NSArray!
    var pageVC:UIPageViewController!
    @IBOutlet var pageIndicator: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.grayColor()
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.whiteColor()
        self.pageVC.delegate = self
        let logolb = UILabel(frame: CGRectMake(0, 0, 30, 70))
        logolb.font =  UIFont(name:"Gotham Bold", size: 15)!
        logolb.textColor = SA_STYPE.TEXT_LABEL_COLOR
        logolb.text = "SNAPART"
        print("self.navigationItem.titleView \(self.navigationItem.titleView)", terminator: "")
        self.navigationItem.titleView = logolb

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkOrder:", name:MESSAGES.NOTIFY.CHECK_ORDER, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkOrder(sender:AnyObject){
        let api = Api()
        api.execute(.GET, url: ApiUrl.my_orders_url, resulf: {(dataResult: (success: Bool, message: String, data: JSON!)) -> Void in
            if(dataResult.success){
                if(dataResult.data.count > 0){
                    let alert = Util().alert2Button(MESSAGES.COMMON.ORDER_EXISTED, parrent: self)
                    alert.addButtonWithTitle("No")
                    alert.addButtonWithTitle("Yes")
                    alert.show()
                }
            }else{
                
            }
            
        })
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 0){
            let api = Api()
            api.execute(.POST, url: ApiUrl.delete_all_order_url, resulf: {(dataResult: (success: Bool, message: String, data: JSON!)) -> Void in
                if(dataResult.success){
                    
                }
            })
        }
        if(buttonIndex == 1){
            let nv = Util().getControllerForStoryBoard("ShoppingCheckoutNC") as! CustomNavigationController
            self.navigationController?.presentViewController(nv, animated: true, completion: nil)
        }
    }
    
    @IBAction func mailFrameTap(sender: AnyObject) {
        let nv = Util().getControllerForStoryBoard("UploadViewVC") as! CustomNavigationController
        self.navigationController?.presentViewController(nv, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pageVC" {
            pageVC = segue.destinationViewController as! UIPageViewController
            pageVC.dataSource = self
            
            let v1:ImageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier("ImageContentVC") as! ImageContentVC
            let v2:ImageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier("ImageContentVC") as! ImageContentVC
            let v3:ImageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier("ImageContentVC") as! ImageContentVC
            let v4:ImageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier("ImageContentVC") as! ImageContentVC
            v1.setBgImage("Home 1")
            v2.setBgImage("Home 2")
            v3.setBgImage("Home 3")
            v4.setBgImage("Home 4")
            
            self.vcArray =  NSArray(objects: v1,v2,v3,v4)
            pageIndicator.currentPage = 0
            let viewControllers = [v1]
            pageVC.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Reverse, animated: false, completion: nil)
            self.pageVC.didMoveToParentViewController(self)
            
        }
        
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = self.vcArray.indexOfObject(viewController)
        if currentIndex > 0  {
            return self.vcArray.objectAtIndex(currentIndex-1) as? UIViewController // return the previous viewcontroller
        } else {
            return nil;// do nothing
        }

    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = self.vcArray.indexOfObject(viewController)
        if ( currentIndex < (self.vcArray.count-1)){
            return self.vcArray.objectAtIndex(currentIndex+1) as? UIViewController // return the previous viewcontroller
        } else {
            return nil; // do nothing
        }
    }
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let index = self.vcArray.indexOfObject(pendingViewControllers.last!)
        print(self.vcArray.indexOfObject(pendingViewControllers.last!))
        self.pageIndicator.currentPage = index
     }
}
