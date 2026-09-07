//
//  AlertsView.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//

import SwiftUI
struct AlertsView: View {
    
    @EnvironmentObject var cooardinator: AppCoordinator
    var body: some View {
        VStack(spacing: 20) {
            
            Text("EsH--War🔥 Alerts🐉")
                .font(.largeTitle)
            
            Text("Alerts screen")
                .font(.title2)
            Button("Notifications") {
                cooardinator.showNotifications()
            }
            Button("Archived") {
                cooardinator.showArchived()
            }
            Button("About") {
                cooardinator.showAbout()
            }
            Button("subscriptions") {
                cooardinator.subscriptions()
            }
            Button("Logout") {
                cooardinator.showLogin()
            }
            
            
            
        }
        .padding()
    }
}
#Preview {
    AlertsView()
}
