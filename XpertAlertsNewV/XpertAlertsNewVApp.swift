
import SwiftUI

@main
struct XpertAlertsNewVApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    private let container = DIContainer()

    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var toastManager = ToastManager()

    var body: some Scene {
 
        WindowGroup {
            RootView(
                coordinator: coordinator,
                container: container,
                logoutUseCase: container.logoutUseCase
            )
            .environmentObject(coordinator)
            .environmentObject(toastManager)
            .modifier(ToastPresenter(manager: toastManager))
            .onAppear {
                coordinator.start(
                    getSavedUserUseCase: container.getSavedUserUseCase
                )
            }
        }

    }
}

