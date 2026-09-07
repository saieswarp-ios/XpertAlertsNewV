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
    var body: some Scene {
        WindowGroup {
            
LoginView(
    
    container: container

)
        }
    }
}
