//
//  AppCoordinator.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//

import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    
    @Published var route: AppRoute = .login
    
    func showLogin() {
        route = .login
    }
        func showAlerts() {
        route = .alerts
    }
    
    func showNotifications() {
        route = .notifications
    }
    func showArchived() {
        route = .archived
    }
    func showAbout() {
        route = .about
    }
    func subscriptions() {
        route = .subscriptions  
    }
}
