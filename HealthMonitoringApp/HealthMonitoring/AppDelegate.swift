//
//  AppDelegate.swift
//  HealthMonitoring
//
//  Created by Muhannad Alghamdi on 4/26/17.
//  Copyright © 2017 Muhannad. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	let firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstViewController") as! FirstViewController
	let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "secondViewController") as! SecondViewController

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		// Change status bar style to light after splash screen finished.
		UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
		
		let pivotPageController = MIPivotPageController.get(rootPages: [firstViewController, secondViewController]) {
			$0.menuView.backgroundColor = UIColor(red:0.97, green:0.07, blue:0.28, alpha:1.00)
			$0.menuView.layer.shadowColor = UIColor.black.cgColor
			$0.menuView.layer.shadowOpacity = 0.3
			$0.menuView.layer.shadowOffset = CGSize(width: 0, height: 2)
			$0.setMenuHeight(60)
			$0.setLightStatusBar(true)
		}
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = pivotPageController
		window?.makeKeyAndVisible()
		
		return true
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
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

