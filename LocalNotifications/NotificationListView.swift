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
    @State private var scheduleDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                if lnManager.isGranted {
                    GroupBox("Schedule") {
                        Button("Interval Notification") {
                            Task {
                                var localNotification = LocalNotification(identifier: UUID().uuidString, title: "Yerel Notifcation", body: "Deneme", timeInterval: 10, repeats: false)
                                localNotification.subtitle = "Alt başlık eklendi"
                                localNotification.bundleImageName = "sand.jpg"
                                await lnManager.schedule(localNotification: localNotification)
                            }
                        }
                        .buttonStyle(.bordered)
                        GroupBox {
                            DatePicker("",selection: $scheduleDate)
                            Button("Calendar Notification") {
                                Task {
                                    let dataComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: scheduleDate)
                                    let localNotification = LocalNotification(identifier: UUID().uuidString,
                                                                              title: "Takvim alarm",
                                                                              body: "Saatli alarm",
                                                                              dateComponents: dataComponents,
                                                                              repeats: false)
                                    await lnManager.schedule(localNotification: localNotification)

                                }
                            }
                            .buttonStyle(.bordered)
                        }
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
