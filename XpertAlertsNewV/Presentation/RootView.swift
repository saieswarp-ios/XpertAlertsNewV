
import SwiftUI

struct RootView: View {

    @ObservedObject var coordinator: AppCoordinator

    let container: DIContainer

    let logoutUseCase: LogoutUseCase

    var body: some View {

        switch coordinator.route {

        // MARK: - Login

        case .login:

            LoginView(
                container: container,
                coordinator: coordinator
            )

        // MARK: - Main Tab Screens

        case .alerts,
             .alertDetails,
             .archived,
             .searchArchived:

            MainTabView(
                container: container,
                coordinator: coordinator,
                logoutUseCase: logoutUseCase
            )
            .fullScreenCover(

                isPresented: Binding(

                    get: {
                        coordinator.route == .alertDetails
                    },

                    set: { isPresented in

                        if !isPresented {
                            coordinator.backToAlerts()
                        }
                    }
                )

            ) {

                if let alert = coordinator.selectedAlert {

                    AlertDetailsView(
                        alert: alert,
                        coordinator: coordinator,
                        container: container,
                        isArchived: true
                    )
                }
            }

        // MARK: - Search Alerts

        case .searchAlerts:

            SearchAlertsView(
                container: container,
                coordinator: coordinator
            )

        // MARK: - Forward Alerts

        case .forwardAlerts:

            NavigationStack {

                ForwardAlertsView(
                    viewModel: container.makeForwardAlertsViewModel(),
                    createForwardAlertViewModel:
                        container.makeCreateForwardAlertViewModel()
                )
            }

        // MARK: - Search

        case .search:

            SearchView(
                container: container,
                coordinator: coordinator
            )

        // MARK: - Change Password

        case .changePassword:

            ChangePasswordView(
                container: container
            )

        // MARK: - About

        case .about:

            AboutView()

        // MARK: - Subscriptions

        case .subscriptions:

            SubscriptionsView(
                container: container
            )

        // MARK: - Build Settings

        case .buildSettings:

            BuildSettingsView(
                coordinator: coordinator
            )
        }
    }
}

