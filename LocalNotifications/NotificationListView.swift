//
// Created for LocalNotifications
// by Stewart Lynch on 2022-05-22
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import SwiftUI

struct NotificationListView: View {
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        NavigationView {
            VStack {
                if lnManager.isGranted {
                    GroupBox("Schedule") {
                        Button("Interval Notification") {
                            Task {
                                let localNotification = LocalNotification(identifier: UUID().uuidString, title: "Tark", body: "Kürek", timeInterval: 10, repeats: false)
                                
                                await lnManager.schedule(localNotification: localNotification)
                            }
                        }
                        .buttonStyle(.bordered)
                        Button("Calendar Notification") {
                            
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(width: 300)
                    List {
                        ForEach(lnManager.pendingRequests, id: \.identifier) { request  in
                            VStack(alignment: .leading) {
                                Text(request.content.title)
                                Spacer()
                                HStack {
                                    Text(request.identifier)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .swipeActions {
                                Button("Delete") {
                                    lnManager.removeRequest(withIdentifier: request.identifier)
                                }
                            }
                        }
                       
                    }
                    
                    
                } else {
                    Button("Enable Notification") {
                        lnManager.openSettings()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Local Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        lnManager.clearRequests()
                    } label: {
                        Image(systemName: "clear.fill")
                            .imageScale(.large)
                    }

                }
            }
        }
        .navigationViewStyle(.stack)
        .task {
            try? await lnManager.requestAuthorization()
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    await lnManager.getPendingRequests()
                }
            }
        }
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
    }
}


/*
 GroupBox("Schedule") {
     Button("Interval Notification") {
         
     }
     .buttonStyle(.bordered)
     Button("Calendar Notification") {
         
     }
     .buttonStyle(.bordered)
 }
 .frame(width: 300)
 // List View Here
 */
