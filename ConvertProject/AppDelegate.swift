//
//  AppDelegate.swift
//  ConvertProject
//
//  Created by Trung Kiên on 7/9/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        var a  = Int(UserDefaults.standard.integer(forKey: "check"))
        gArrayListUser = NSMutableArray()
        if a == 0 {
            checkViewLogin()
        } else {
            checkViewHome()
        }
     
        return true
    }
    func checkViewHome() -> Void {
        window = UIWindow(frame: UIScreen.main.bounds)
        let home : HomeViewController = HomeViewController()
        let narHome : UINavigationController = UINavigationController.init(rootViewController: home)
        narHome.isNavigationBarHidden = true
        
        let menu = MenuViewController()
        
        let reveal : SWRevealViewController = SWRevealViewController(rearViewController: menu, frontViewController: narHome)
        
        window?.rootViewController = reveal
        window?.makeKeyAndVisible()
    }
    func checkViewLogin() -> Void {
        window = UIWindow(frame: UIScreen.main.bounds)
        let login : LoginViewController = LoginViewController()
        let narlogin = UINavigationController.init(rootViewController: login)
        narlogin.isNavigationBarHidden = true
        window?.rootViewController = narlogin
        window?.makeKeyAndVisible()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }
}

