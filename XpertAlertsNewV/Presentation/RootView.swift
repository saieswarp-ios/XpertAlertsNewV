import SwiftUI

struct RootView: View {

    @ObservedObject var coordinator: AppCoordinator
    let container: DIContainer

    var body: some View {

        switch coordinator.route {

        case .login:
            LoginView(
                container: container,
                coordinator: coordinator
            )

        case .alerts:
           MainTabView()

        case .search:
            SearchView()

        case .changePassword:
            ChangePasswordView()

        case .notifications:
            NotificationsView()

        case .archived:
            ArchivedView()

        case .about:
            AboutView()

        case .subscriptions:
            SubscriptionsView()
        case .buildSettings:
            BuildSettingsView()

        }
    }
}
