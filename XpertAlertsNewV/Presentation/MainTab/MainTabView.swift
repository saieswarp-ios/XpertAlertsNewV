
import SwiftUI

struct MainTabView: View {

    let container: DIContainer

    @ObservedObject var coordinator: AppCoordinator

    let logoutUseCase: LogoutUseCase

    // 0 = Alerts, 1 = Forward, 2 = Archived, 3 = More
    @State private var selectedTab = 0

    var body: some View {

        TabView(selection: $selectedTab) {

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
            .tag(0)

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
            .tag(1)

            // MARK: - Archived

            Group {

                if coordinator.route == .searchArchived {

                    // Show search inside the Archived tab.
                    ArchivedSearchView(
                        coordinator: coordinator
                    )

                } else {

                    ArchivedView(
                        container: container,
                        coordinator: coordinator
                    )
                }
            }
            .tabItem {
                Label(
                    "Archived",
                    systemImage: "archivebox.fill"
                )
            }
            .tag(2)

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
            .tag(3)
        }
        .tint(Color.themeOrange)
        .onAppear {
            selectTab(for: coordinator.route)
        }
        .onChange(of: coordinator.route) { newRoute in
            selectTab(for: newRoute)
        }
    }

    // MARK: - Select Tab Based on Coordinator Route

    private func selectTab(for route: AppRoute) {

        switch route {

        case .alerts, .alertDetails:
            selectedTab = 0

        case .archived, .searchArchived:
            selectedTab = 2

        case .forwardAlerts:
            selectedTab = 1

        default:
            break
        }
    }
}

