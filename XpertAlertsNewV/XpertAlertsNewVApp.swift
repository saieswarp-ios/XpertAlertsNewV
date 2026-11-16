
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
            .environment(\.font, .avenirRegular(size: 16))
           // .font(.custom("PlaywriteUSModern-Regular", size: 16))
            
            
           
            .onAppear {
                coordinator.configure(
                    userRepository: container.userRepository,
                    logoutUseCase: container.logoutUseCase
                )

                coordinator.start(
                    getSavedUserUseCase: container.getSavedUserUseCase
                )
            }
            .onReceive(
                NotificationCenter.default.publisher(for: .sessionExpired)
            ) { _ in
                print("🔴 SESSION EXPIRED - AUTOMATIC LOGOUT")
                coordinator.logout()
            }

        }

    }
}

