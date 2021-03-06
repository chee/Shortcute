//
//  AppDelegate.swift
//  Shortcute
//
//  Created by chee on 07/10/2018.
//  Copyright © 2018 snoots & co. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
	static var deviceToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

		application.registerForRemoteNotifications()

        return true
    }
	
	func convertDataTokenToString (_ token: Data) -> String {
		return token.reduce("", {"\($0)\(String(format: "%02x", $1))"})
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken token: Data) {
		print("i registered for push notifications")
		AppDelegate.deviceToken = convertDataTokenToString(token)
		if let token = AppDelegate.deviceToken {
			print(token)
		} else {
			print("and got fuck all")
		}
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		
		print("hi i got a notification?")

		if let shortcutes = Shortcute.loadAllFromDisk() {
			let shortcute = shortcutes[0]
			shortcute.open()
		} else {
			print("couldnt load shortcuts")
		}
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

