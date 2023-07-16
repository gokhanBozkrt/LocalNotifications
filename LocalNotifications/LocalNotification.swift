//
//  LocalNotification.swift
//  LocalNotifications
//
//  Created by Gökhan Bozkurt on 16.07.2023.
//

import Foundation

struct LocalNotification {
    var identifier: String
    var scheduleType: ScheduleType
    var title: String
    var body: String
    var timeInterval: Double?
    var dateComponents: DateComponents?
    var repeats: Bool
    var subtitle: String?
    var bundleImageName: String?
    
    init(identifier: String, title: String, body: String, timeInterval: Double, repeats: Bool) {
        self.identifier = identifier
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
        self.scheduleType = .time
    }
    
    init(identifier: String, title: String, body: String, dateComponents: DateComponents?, repeats: Bool) {
        self.identifier = identifier
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
        self.scheduleType = .calendar
    }
    
    
    enum ScheduleType {
        case time,calendar
    }
    
}
