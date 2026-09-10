//
//  RootView.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//

import SwiftUI
struct RootView: View {
    
    @ObservedObject var cooardinator: AppCoordinator
    
    let container: DIContainer
    
    var body: some View {
        
        switch cooardinator.route {
   case .login:
       LoginView(container: container,
       coordinator: cooardinator)
     
       
   case .alerts:
       AlertsView(
        getAlertsUseCase: container.getAlertsUseCase, 
        logoutUseCase: container.logoutUseCase
       )
            
            
        case .changePassword:
            ChangePasswordView()
       
   case .about:
       AboutView()
   case .notifications:
       NotificationsView()
   case .subscriptions:
       SubscriptionsView()
        case .archived:
            ArchivedView()
       
        }
    }
}





