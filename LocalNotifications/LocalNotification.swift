//
//  LocalNotification.swift
//  LocalNotifications
//
//  Created by Gökhan Bozkurt on 16.07.2023.
//

import Foundation

struct LocalNotification {
    var identifier: String
    var title: String
    var body: String
    var timeInterval: Double
    var repeats: Bool
}
