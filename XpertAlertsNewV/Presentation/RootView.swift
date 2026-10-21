
import SwiftUI

struct RootView: View {

    @ObservedObject var coordinator: AppCoordinator

    let container: DIContainer
    let logoutUseCase: LogoutUseCase

    var body: some View {
        switch coordinator.route {

        case .login:
            LoginView(
                container: container,
                coordinator: coordinator
            )

            
            
          
            case .alerts, .alertDetails:

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
                            container: container
                        )
                    }
                }
         
            
            
            
            
            
//        case .alerts:
//            MainTabView(
//                container: container,
//                coordinator: coordinator,
//                logoutUseCase: logoutUseCase
//            )

        case .searchAlerts:
            SearchAlertsView(
                container: container,
                coordinator: coordinator
            )

//        case .alertDetails:
//            if let alert = coordinator.selectedAlert {
//                AlertDetailsView(
//                    alert: alert,
//                    coordinator: coordinator,
//                    container: container
//                )
//            }

        case .forwardAlerts:
            NavigationStack {
                ForwardAlertsView(
                    viewModel: container.makeForwardAlertsViewModel(),
                    createForwardAlertViewModel:
                        container.makeCreateForwardAlertViewModel()
                )
            }

        case .search:
            SearchView(
                container: container,
                coordinator: coordinator
            )

        case .changePassword:
            ChangePasswordView(container: container)

        case .archived:
            ArchivedView(
                container: container,
                coordinator: coordinator
            )

        case .about:
            AboutView()

        case .subscriptions:
            SubscriptionsView(container: container)

        case .buildSettings:
            BuildSettingsView(
                coordinator: coordinator
            )
        }
    }
}

