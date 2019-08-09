
import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window                  : UIWindow?
    
    //------------------------------------------------------------------------------------
    // MARK:- WEBCALL for notifications.
    //------------------------------------------------------------------------------------
    /*
     // Header :
     {
     Authorization:key=\(YOUR_SERVER_KEY),
     Content-Type :application/json
     }
     // Request Params
     {
     "to": "\(YOUR_FCM_TOKEN)",
     "content_available": true,
     "mutable_content": true,
     "notification" : {
     "body" : "This is a Firebase Cloud Messaging Topic Message!",
     "title" : "FCM Message",
     "click_action": "ACTION_CATEGORY",
     "category": "CustomSamplePush"
     },
     "data": {
     "image_url": "https://www.decentfashion.in/wp-content/uploads/2018/12/jai-sri-ram-image-40.jpg",
     "video_url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
     }
     }
     */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ granted, error in }
        } else { // iOS 9 support
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        
        application.registerForRemoteNotifications()
        
        // Click_action
        let likeAction = UNNotificationAction(identifier: "meow", title: "Meow", options: [])
        let addToCartAction = UNNotificationAction(identifier: "pizza", title: "Pizza?", options: [])
        let category = UNNotificationCategory(identifier: "CustomSamplePush", actions: [likeAction, addToCartAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        Messaging.messaging().delegate = self
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
//------------------------------------------------------------------------------------
// MARK:- Notifications Delegate
//------------------------------------------------------------------------------------
extension AppDelegate : MessagingDelegate , UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error : \(error.localizedDescription)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcmToken : \(fcmToken)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("") { $0 + String(format: "%02X", $1) }
        print("APNs device token: \(deviceTokenString)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "meow" {
            //Do something...
        }
        if response.actionIdentifier == "pizza" {
            //Do something else...
        }
        completionHandler()
    }
    
}
