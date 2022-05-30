import UIKit
import Flutter
import CleverTapSDK
import clevertap_plugin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      CleverTap.autoIntegrate() // integrate CleverTap SDK using the autoIntegrate option
      CleverTapPlugin.sharedInstance()?.applicationDidLaunch(options: launchOptions)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        CleverTap.sharedInstance()?.setPushToken(deviceToken as Data)
    }
}
