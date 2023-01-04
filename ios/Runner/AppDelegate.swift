import UIKit
import Flutter
import CleverTapSDK
import clevertap_plugin

@available(iOS 10.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)

      registerPush()
      CleverTap.autoIntegrate() // integrate CleverTap SDK using the autoIntegrate option
      CleverTapPlugin.sharedInstance()?.applicationDidLaunch(options: launchOptions)
      UNUserNotificationCenter.current().delegate = self
      
      let defaults = UserDefaults.init(suiteName: "group.flutter.fct")
      
      let email2 = defaults?.value(forKey: "email")

      print("email2 \(email2)")
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    private func registerPush() {
        UNUserNotificationCenter.current().delegate = self
        let action1 = UNNotificationAction(identifier: "action_1", title: "Back", options: [])
        let action2 = UNNotificationAction(identifier: "action_2", title: "Next", options: [])
        let action3 = UNNotificationAction(identifier: "action_3", title: "View In App", options: [])
        let category = UNNotificationCategory(identifier: "CTNotification", actions: [action1, action2, action3], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        // request permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {
            (granted, error) in
            if (granted) {
                DispatchQueue.main.async {
                   UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("token",token)
        CleverTap.sharedInstance()?.setPushToken(deviceToken as Data)
    }
    
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .badge, .sound])
        
        CleverTap.sharedInstance()?.handleNotification(withData: notification.request.content.userInfo, openDeepLinksInForeground: true)
        completionHandler([.badge, .sound, .alert])
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            
        
        CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo)
        
        completionHandler()
            
    }
}
