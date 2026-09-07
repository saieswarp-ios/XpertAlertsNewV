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
    
    @StateObject private var cooardinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            
            RootView(cooardinator: cooardinator, container: container)
                .environmentObject(cooardinator)
        }
    }
}
