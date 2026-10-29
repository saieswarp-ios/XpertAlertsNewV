//
//  AppDelegate.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 21/10/26.
//


import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging
//import FirebaseAnalytics

final class AppDelegate: NSObject,
                         UIApplicationDelegate,
                         UNUserNotificationCenterDelegate,
                         MessagingDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        FirebaseApp.configure()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .badge, .sound]
            ) { granted, error in

                if let error = error {
                    print("Notification permission error:", error)
                    return
                }

                print("Notification permission granted:", granted)

                guard granted else { return }

                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }

        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs registration succeeded")
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("APNs registration failed:", error)
    }

 
  
    
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        print("FCM registration token callback called")

        guard let fcmToken, !fcmToken.isEmpty else {
            print("FCM token is nil or empty")
            return
        }

        // Save the latest FCM token locally.
        UserDefaults.standard.set(fcmToken, forKey: "FirebaseToken")
        print("FCM token saved locally")

        
        // TEMPORARY: Print the token for Firebase testing.
        print("FCM TOKEN:", fcmToken)
        
        
        
        
        
        // Register the token with the XpertAlerts server.
        Task {
            await FCMTokenRegistrationService().registerToken(fcmToken)
        }
    }




    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .badge, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
