//
//  NotificationService.swift
//  fct_push
//
//  Created by Gaurav Singh on 30/05/22.
//


import UserNotifications

import CTNotificationService
import CleverTapSDK

 class NotificationService: CTNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
 
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping(UNNotificationContent) -> Void) {
        print("in notification service")
        let defaults = UserDefaults.init(suiteName: "group.flutter.fct")
        
        let email2 = defaults?.value(forKey: "email")

        print("email2 \(email2)")
            let profile: Dictionary<String, Any> =
           [
            "Email": email2 as Any,
           ]

        if(email2 != nil){
            CleverTap.sharedInstance()?.onUserLogin(profile)
        }
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: request.content.userInfo)
        super.didReceive(request, withContentHandler:contentHandler)
 }
}
