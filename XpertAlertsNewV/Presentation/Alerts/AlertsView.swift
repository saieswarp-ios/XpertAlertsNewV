//
//  AlertsView.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//

import SwiftUI
struct AlertsView: View {
    @StateObject private var viewModel: AlertsViewModel
    @EnvironmentObject var cooardinator: AppCoordinator
    let logoutUseCase: LogoutUseCase
    
    init(getAlertsUseCase: GetAlertsUseCase,
         logoutUseCase: LogoutUseCase
         
    ) {
        _viewModel = StateObject(
            
            wrappedValue: AlertsViewModel(getAlertsUseCase: getAlertsUseCase)
        )
        self.logoutUseCase = logoutUseCase
        
    }
    
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
                logoutUseCase.execute()
                cooardinator.showLogin()
            }
            
            
            
        }
        .padding()
        .onAppear {
            viewModel.loadAlerts()
        }
    }
}

