//
//  AppDelegate.swift
//  Task
//
//  Created by Ahmad Shraby on 4/30/20.
//  Copyright © 2020 sHiKoOo. All rights reserved.
//

import UIKit
import UserNotificationsUI
import UserNotifications
import Firebase
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var badgeCount = 0
    var notifID = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        registerForRemoteNotification()
        
        return true
    }
    
    
    
    // MARK:- Notifications **************************************************************
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    
                    print("Permission granted: \(granted)")
                    guard granted else { return }
                    self.getNotificationSettings()
                }
            }
            
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // Save device firebase token to use it with backend
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        // convert device token from data to string
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid)
        }
        // save the device token and send to backend
        if let savedAPNSToken = UserDefaults.standard.object(forKey: "savedAPNSToken") as? String {
            if savedAPNSToken != token {
                UserDefaults.standard.set(token, forKey: "savedAPNSToken")
                UserDefaults.standard.synchronize()
                Messaging.messaging().apnsToken = deviceToken
                
                
            }
        }
        
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    // MARK: - Dynamic Links **************************************************************
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingUrl = userActivity.webpageURL {
            print("Incoming URL: \(incomingUrl)")
            
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamicLink, error) in
                // ...
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLinks(dynamicLink)
                }
            }
            if linkHandled {
                return true
            }else {
                return false
            }
        }
        return false
    }
    
    func handleIncomingDynamicLinks(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else { return }
        print("Incoming Link Parameters: \(url.absoluteString)")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else { return }
        
        for queryItem in queryItems {
            print("Parameter \(queryItem.name) has value \(queryItem.value ?? "value")")
        }
        
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return application(app, open: url,
                           sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                           annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("Custom Scheme URL: \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            // Handle the deep link. For example, show the deep-linked content or
            self.handleIncomingDynamicLinks(dynamicLink)
            // apply a promotional offer to the user's account.
            // ...
            return true
        }else {
            return false
        }
    }
}




@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // This function will be called when the app receive notification
    // Get notification data from notification like ID or any data from it and increase badge number of app icon
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let notificationID = userInfo["_id"] as? String {
            print("Notification ID: \(notificationID)")
            
            UIApplication.shared.applicationIconBadgeNumber += badgeCount
            NotificationCenter.default.post(name: Notification.Name("notif"), object: nil)
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        if let notificationID = userInfo["_id"] as? String {
            print("Notification ID: \(notificationID)")
            
            // Check if the user is logged in
            // Clear app icon badge number
            UIApplication.shared.applicationIconBadgeNumber = 0
            // Get notification details by ID from backend
            // Handle the notification click to redirect the user to which view controller in the application
            
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}





extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        // Save user firebase token with User Defaults in the device
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        // Save user firebase token with User Defaults in the device
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
    }
    
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}
