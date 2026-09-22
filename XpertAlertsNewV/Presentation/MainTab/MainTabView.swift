import SwiftUI

struct MainTabView: View {

    let container: DIContainer

    var body: some View {

        TabView {

            AlertsView(
                viewModel: container.makeAlertsViewModel()
            )
            .tabItem {
                Label(
                    "Alerts",
                    systemImage: "bell.fill"
                )
            }

            SearchView()
                .tabItem {
                    Label(
                        "Search",
                        systemImage: "magnifyingglass"
                    )
                }

            ArchivedView()
                .tabItem {
                    Label(
                        "Archived",
                        systemImage: "archivebox.fill"
                    )
                }

            MoreView()
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
