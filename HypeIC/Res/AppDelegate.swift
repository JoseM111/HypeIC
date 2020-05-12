//
//  AppDelegate.swift
//  HypeIC
//
//  Created by Jose Martinez on 5/11/20.
//  Copyright © 2020 Jose Martinez. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: _@
    /**©------------------------------------------------------------------------------©*/
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Access the user notification center
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { userDidAllow, error in
            if let error = error {
                printf("Error in \(#function) : \(error.localizedDescription)\n\(error)")
            }

            if userDidAllow == true {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }

        return true
    }
    /**©------------------------------------------------------------------------------©*/
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        HypeModelController.shared.subscribeToRemoteNotifications { (error) in
            if let error = error {
            printf("\(error.localizedDescription)")
            }
        }
    }
    /**©------------------------------------------------------------------------------©*/
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printf("\(error.localizedDescription)")
    }
    /**©------------------------------------------------------------------------------©*/
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        HypeModelController.shared.fetchAllHypes { success in
            // No handling error for this app

        }
    }
    /**©------------------------------------------------------------------------------©*/
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}/// END OF CLASS

