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
    @Published var pendingAlertSearchFilters: AlertSearchFilters?
    @Published var savedAlertSearchFilters: AlertSearchFilters?
    private var userRepository: UserRepository?
    private var logoutUseCase: LogoutUseCase?
    
    var selectedAlert: Alert?
    @Published var refreshAlertsAfterAction = false
    
//    func start(
//        getSavedUserUseCase: GetSavedUserUseCase
//    ) {
//        if getSavedUserUseCase.execute() != nil {
//            route = .alerts
//        }else {
//            route = .login
//            
//        }
//    }
    
  
    func start(
        getSavedUserUseCase: GetSavedUserUseCase
    ) {
        route = .login
    }
    

    func showAlertDetails(_ alert: Alert) {
        selectedAlert = alert
        route = .alertDetails
    }
    
    func backToAlerts() {
        selectedAlert = nil
        route = .alerts
    }
    
    
    func showSearchAlerts() {
        route = .searchAlerts
    }
    
    
    func applyAlertSearch(filters: AlertSearchFilters) {
        savedAlertSearchFilters = filters
        pendingAlertSearchFilters = filters
        route = .alerts
    }

    
    
    
    func showLogin() {
        route = .login
    }
    func configure(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func configure(
        userRepository: UserRepository,
        logoutUseCase: LogoutUseCase
    ) {
        self.userRepository = userRepository
        self.logoutUseCase = logoutUseCase
    }
    
    
    func logout() {
        logoutUseCase?.execute()
        selectedAlert = nil
        route = .login
    }
    
        func showAlerts() {
        route = .alerts
    }
    
    func showChangePassword() {
        route = .changePassword
    }
    
    func showSearch() {
        route = .search
    }
//    
//    func showNotifications() {
//        route = .notifications
//    }
    func showArchived() {
        route = .archived
    }
    func showAbout() {
        route = .about
    }
    func subscriptions() {
        route = .subscriptions  
    }
    func showBuildSettings() {
        route = .buildSettings
    }
    func showForwardAlerts() {
        route = .forwardAlerts
    }
    func backToAlertDetails() {
        route = .alertDetails
    }
    
   
}
