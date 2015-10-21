//
//  AppDelegate.swift
//  SnapArt
//
//  Created by HD on 10/6/15.
//  Copyright (c) 2015 Duc Ngo Hoai. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import FBSDKCoreKit
import FBSDKLoginKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate   {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if(MemoryStoreData().getBool(MemoryStoreData.user_stayed_login)){
            Api().execute(ApiMethod.POST, url: ApiUrl.signin_url, parameters: [APIKEY.EMAIL:MemoryStoreData().getString(MemoryStoreData.user_email), APIKEY.PWD:MemoryStoreData().getString(MemoryStoreData.user_pwd)], resulf: {(dataResult: (success: Bool, message: String, data: AnyObject!)) -> Void in
                if(dataResult.success){
                    if let dat = dataResult.data as? NSMutableDictionary {
                        var tokenStr = ""
                        var idNumb = 0
                        
                        if let str = dat.objectForKey(APIKEY.ACCESS_TOKEN) as? String {
                            tokenStr = str
                        }
                        
                        if let numb = dat.objectForKey(APIKEY.ACCOUNT_ID) as? Int {
                            idNumb = numb
                            
                        }
                        
                        let account = Account()
                        account.setAcountInfo(accessTokenStr: tokenStr, accountID: idNumb)
                        DataManager.sharedInstance.user = account
                        NSNotificationCenter.defaultCenter().postNotificationName(MESSAGES.NOTIFY.LOGIN_SUCCESS, object: nil)
                    }
                }
            })
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Override point for customization after application launch.
//        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}

