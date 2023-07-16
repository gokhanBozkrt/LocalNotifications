//
//  LocalNotificationCenter.swift
//  LocalNotifications
//
//  Created by Gökhan Bozkurt on 16.07.2023.
//

import Foundation
import NotificationCenter
@MainActor
class LocalNotificationManager: NSObject,ObservableObject, UNUserNotificationCenterDelegate {
  
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGranted = false
    @Published var pendingRequests: [UNNotificationRequest] = []
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    // Delegate function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.sound,.banner,.badge,.list]
    }
    
    
    
    
    func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound,.badge,.alert])
        
    }
    
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
        print(isGranted)
    }
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    
    func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        if let subtitle = localNotification.subtitle {
            content.subtitle = subtitle
        }
        if let bundleImageName = localNotification.bundleImageName {
            if let url = Bundle.main.url(forResource: bundleImageName, withExtension: "") {
                if let attachment = try? UNNotificationAttachment(identifier: bundleImageName, url: url) {
                    content.attachments = [attachment]
                }
            }
        }
        content.body = localNotification.body
        content.sound = .default
        
        if localNotification.scheduleType == .time {
            guard let timeInterval = localNotification.timeInterval else { return }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: localNotification.repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        } else {
            guard let dateComponents = localNotification.dateComponents else { return }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: localNotification.repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        }
       
        await getPendingRequests()
    }
    
    func getPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
        print("Pending: \(pendingRequests.count)")
    }
    
    
    func removeRequest(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequests.firstIndex(where:  { $0.identifier == identifier }) {
            pendingRequests.remove(at: index)
            print("Pending: \(pendingRequests.count)")
        }
    }
    
    func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequests.removeAll(keepingCapacity: false)
        print("Pending: \(pendingRequests.count)")

    }
    
}
