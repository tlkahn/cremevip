//
//  AppDelegate.swift
//  cremevip
//
//  Created by toeinriver on 10/12/16.
//  Copyright © 2016 toeinriver. All rights reserved.
//

import UIKit

extension UILabel {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
    
}

extension UIButton {
    
    var substituteFontName : String {
        get { return self.titleLabel!.font.fontName}
        set {
            if (self.titleLabel != nil) {
                self.titleLabel!.font = UIFont(name: newValue, size: self.titleLabel!.font.pointSize)! }
            }
            
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.statusBarHidden = true
        UILabel.appearance().substituteFontName = "din-regular"
        UIButton.appearance().substituteFontName = "din-regular"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let left = storyboard.instantiateViewControllerWithIdentifier("searchVc")
        let middle = storyboard.instantiateViewControllerWithIdentifier("mainNavVc") as! UINavigationController
        let right = storyboard.instantiateViewControllerWithIdentifier("enrolledVc")
        
        let snapContainer = SnapContainerViewController.containerViewWith(left,
                                                                          middleVC: middle,
                                                                          rightVC: right)
        self.window?.rootViewController = snapContainer
        self.window?.makeKeyAndVisible()
        
        return true
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

