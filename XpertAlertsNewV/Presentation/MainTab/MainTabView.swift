import SwiftUI

struct MainTabView: View {

    let container: DIContainer
    let coordinator: AppCoordinator
    let logoutUseCase: LogoutUseCase

    var body: some View {

        TabView {

            // MARK: - Alerts

            AlertsView(
                container: container,
                coordinator: coordinator
            )
            .tabItem {
                Label(
                    "Alerts",
                    systemImage: "bell.fill"
                )
            }

            // MARK: - Forward Alerts

            NavigationStack {
                ForwardAlertsView(
                    viewModel: container.makeForwardAlertsViewModel(),
                    createForwardAlertViewModel:
                        container.makeCreateForwardAlertViewModel()
                )
            }
            .tabItem {
                Label(
                    "Forward",
                    systemImage: "arrowshape.turn.up.right.fill"
                )
            }

            // MARK: - Archived

            ArchivedView(
                container: container,
                coordinator: coordinator
            )
            .tabItem {
                Label(
                    "Archived",
                    systemImage: "archivebox.fill"
                )
            }

            // MARK: - More

            MoreView(
                coordinator: coordinator,
                logoutUseCase: logoutUseCase,
                container: container
            )
            .tabItem {
                Label(
                    "More",
                    systemImage: "ellipsis.circle.fill"
                )
            }
        }
        .tint(Color.themeOrange)
    }
}

