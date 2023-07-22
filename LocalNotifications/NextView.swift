//
//  NextView.swift
//  LocalNotifications
//
//  Created by Gökhan Bozkurt on 22.07.2023.
//

import SwiftUI

enum NextView: String, Identifiable {
    case promo,renew
    var id: String {
        self.rawValue
    }
    
 @ViewBuilder func view() -> some View {
        switch self {
        case .promo:
            Text("Promotional Offer")
                .font(.largeTitle)
        case .renew:
            VStack {
                Text("Renew Subscription")
                    .font(.largeTitle)
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 129))
            }
        }
    }
}
