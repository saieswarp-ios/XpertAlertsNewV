//
//  XpertAlertsNewVApp.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//

import SwiftUI

@main
struct XpertAlertsNewVApp: App {
    
    private let container = DIContainer()
    
    @StateObject private var coordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            
            RootView(
                coordinator: coordinator,
                container: container
            )
                .environmentObject(coordinator)
                .onAppear {
                    coordinator.start(getSavedUserUseCase: container.getSavedUserUseCase)
                }
        }
    }
}
