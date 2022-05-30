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
     
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: request.content.userInfo)
        super.didReceive(request, withContentHandler:contentHandler)
 }
}
