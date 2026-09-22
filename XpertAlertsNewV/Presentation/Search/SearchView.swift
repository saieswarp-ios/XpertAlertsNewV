//import SwiftUI
//
//struct SearchView: View {
//
//    @State private var searchText = ""
//    @State private var selectedApplication = "All Applications"
//    @State private var selectedPeriod = "Last 3 Days"
//
//    private let applications = [
//        "All Applications",
//        "Production",
//        "Server Monitor",
//        "Backup Service"
//    ]
//
//    private let periods = [
//        "Today",
//        "Last 3 Days",
//        "Last 7 Days",
//        "Last 30 Days"
//    ]
//
//    var body: some View {
//
//        ScrollView {
//
//            VStack(
//                alignment: .leading,
//                spacing: 24
//            ) {
//
//                // Screen Header
//
//                AppScreenHeader(
//                    title: "Search",
//                    subtitle: "Find and filter your alerts",
//                    icon: "magnifyingglass",
//                    iconColor: .themeOrange
//                )
//
//                // Search
//
//                AppCard {
//
//                    VStack(
//                        alignment: .leading,
//                        spacing: 12
//                    ) {
//
////                        SectionTitle(
////                            title: "Search Alerts",
////                            subtitle: "Search by alert name or message.",
////                            icon: "magnifyingglass"
////                        )
//
//                        HStack(spacing: 10) {
//
//                            Image(systemName: "magnifyingglass")
//                                .foregroundStyle(
//                                    Color.primary
//                                )
//
//                            TextField(
//                                "Search alerts...",
//                                text: $searchText
//                            )
//                            .textInputAutocapitalization(.never)
//                            .autocorrectionDisabled()
//
//                            if !searchText.isEmpty {
//
//                                Button {
//
//                                    searchText = ""
//
//                                } label: {
//
//                                    Image(
//                                        systemName:
//                                            "xmark.circle.fill"
//                                    )
//                                    .foregroundStyle(
//                                        .secondary
//                                    )
//                                }
//                            }
//                        }
//                        .padding(14)
//                        .background(
//                            Color(
//                                .tertiarySystemBackground
//                            ),
//                            in: RoundedRectangle(
//                                cornerRadius: 14
//                            )
//                        )
//                    }
//                }
//
//                //  Filtersss
//
//                VStack(
//                    alignment: .leading,
//                    spacing: 14
//                ) {
//
////                    SectionTitle(
////                        title: "Filters",
////                        subtitle: "Narrow down your results.",
////                        icon: "line.3.horizontal.decrease.circle"
////                    )
//
//                    // Application
//
//                    filterRow(
//                        title: "Application",
//                        icon: "square.grid.2x2.fill"
//                    ) {
//
//                        Picker(
//                            "Application",
//                            selection:
//                                $selectedApplication
//                        ) {
//
//                            ForEach(
//                                applications,
//                                id: \.self
//                            ) { application in
//
//                                Text(application)
//                                    .tag(application)
//                            }
//                        }
//                        .pickerStyle(.menu)
//                    }
//
//                    // Date Range
//
//                    filterRow(
//                        title: "Date Range",
//                        icon: "calendar"
//                    ) {
//
//                        Picker(
//                            "Date Range",
//                            selection: $selectedPeriod
//                        ) {
//
//                            ForEach(
//                                periods,
//                                id: \.self
//                            ) { period in
//
//                                Text(period)
//                                    .tag(period)
//                            }
//                        }
//                        .pickerStyle(.menu)
//                    }
//                }
//
//                //Apply Search
//
//                Button {
//
//                    print("Search tapped")
//                    print("Search:", searchText)
//                    print(
//                        "Application:",
//                        selectedApplication
//                    )
//                    print(
//                        "Period:",
//                        selectedPeriod
//                    )
//
//                } label: {
//
//                    HStack(spacing: 10) {
//
//                        Image(
//                            systemName: "magnifyingglass"
//                        )
//
//                        Text("Apply Search")
//                            .font(
//                                .system(
//                                    size: 16,
//                                    weight: .semibold
//                                )
//                            )
//
//                        Spacer()
//
//                        Image(
//                            systemName: "arrow.right"
//                        )
//                    }
//                    .foregroundStyle(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 16)
//                    .padding(.horizontal, 18)
//                    .background(
//                        Color.themeOrange,
//                        in: RoundedRectangle(
//                            cornerRadius: 15
//                        )
//                    )
//                }
//                .buttonStyle(.plain)
//
//                //  Quick Filters
//
////                VStack(
////                    alignment: .leading,
////                    spacing: 14
////                ) {
////
////                    SectionTitle(
////                        title: "Quick Filters",
////                        subtitle: "Start with a common search.",
////                        icon: "bolt.fill"
////                    )
//
////                    QuickFilterRow(
////                        title: "Critical Alerts",
////                        subtitle:
////                            "Show critical alerts only",
////                        icon:
////                            "exclamationmark.triangle.fill"
////                    )
////
////                    QuickFilterRow(
////                        title: "Today's Alerts",
////                        subtitle:
////                            "Alerts received today",
////                        icon: "calendar"
////                    )
////
////                    QuickFilterRow(
////                        title: "Recent Alerts",
////                        subtitle:
////                            "Alerts from the last 3 days",
////                        icon: "clock.fill"
////                    )
//                }
//            }
//            .padding(.horizontal, 16)
//            .padding(.top, 20)
//            .padding(.bottom, 30)
//        }
////        .background(
////            Color(.systemGroupedBackground)
////                .ignoresSafeArea()
////        )
//    }
//
//
//    //  Filter Row
//
//    @ViewBuilder
//    private func filterRow<Content: View>(
//        title: String,
//        icon: String,
//        @ViewBuilder content: () -> Content
//    ) -> some View {
//
//        HStack(spacing: 12) {
//
//            Image(systemName: icon)
//                .font(
//                    .system(
//                        size: 16,
//                        weight: .semibold
//                    )
//                )
//                .foregroundStyle(
//                    Color.primary
//                )
//                .frame(
//                    width: 36,
//                    height: 36
//                )
//                .background(
//                    Color.primary.opacity(0.12),
//                    in: RoundedRectangle(
//                        cornerRadius: 10
//                    )
//                )
//
//            Text(title)
//                .font(
//                    .system(
//                        size: 14,
//                        weight: .semibold
//                    )
//                )
//
//            Spacer(minLength: 8)
//
//            content()
//                .tint(Color.themeOrange)
//                .fixedSize(horizontal: true, vertical: false)
//        }
//        .padding(14)
//        .background(
//            Color(.secondarySystemBackground),
//            in: RoundedRectangle(
//                cornerRadius: 16
//            )
//        )
//    }
//
//
//
////// MARK: - Quick Filter Row
////
////struct QuickFilterRow: View {
////
////    let title: String
////    let subtitle: String
////    let icon: String
////
////    var body: some View {
////
////        Button {
////
////            print("\(title) tapped")
////
////        } label: {
////
////            HStack(spacing: 14) {
////
////                Image(systemName: icon)
////                    .font(
////                        .system(
////                            size: 17,
////                            weight: .semibold
////                        )
////                    )
////                    .foregroundStyle(
////                        Color.primary
////                    )
////                    .frame(
////                        width: 42,
////                        height: 42
////                    )
////                    .background(
////                        Color.primary.opacity(0.12),
////                        in: RoundedRectangle(
////                            cornerRadius: 12
////                        )
////                    )
////
////                VStack(
////                    alignment: .leading,
////                    spacing: 4
////                ) {
////
////                    Text(title)
////                        .font(
////                            .system(
////                                size: 15,
////                                weight: .semibold
////                            )
////                        )
////                        .foregroundStyle(.primary)
////
////                    Text(subtitle)
////                        .font(
////                            .system(
////                                size: 12
////                            )
////                        )
////                        .foregroundStyle(.secondary)
////                }
////
////                Spacer()
////
////                Image(
////                    systemName: "chevron.right"
////                )
////                .font(
////                    .system(
////                        size: 12,
////                        weight: .bold
////                    )
////                )
////                .foregroundStyle(.secondary)
////            }
////            .padding(14)
////            .background(
////                Color(.secondarySystemBackground),
////                in: RoundedRectangle(
////                    cornerRadius: 17
////                )
////            )
////        }
////        .buttonStyle(.plain)
////    }
////}




import SwiftUI

struct SearchView: View {

    @State private var searchText = ""
    @State private var selectedApplication = "Applications"
    @State private var selectedPeriod = "Today"

    let applications = [
        "Applications",
        "Production",
        "Server Monitor",
        "Backup Service"
    ]

    let periods = [
        "Today",
        "Last 3 Days",
        "Last 7 Days",
        "Last 30 Days"
    ]

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                // Existing header
                AppScreenHeader(
                    title: "Search",
                    subtitle: nil,
                    icon: "magnifyingglass"
                )

                // Search text
                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {

                    Text("Search")
                        .font(.system(size: 14, weight: .medium))

                    TextField(
                        "Search alerts",
                        text: $searchText
                    )
                    .textFieldStyle(.roundedBorder)
                }

                // Application
                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {

                    Text("Application")
                        .font(.system(size: 14, weight: .medium))

                    Picker(
                        "Application",
                        selection: $selectedApplication
                    ) {

                        ForEach(
                            applications,
                            id: \.self
                        ) { application in

                            Text(application)
                                .tag(application)
                        }
                    }
                    .pickerStyle(.menu)
                }

                // Period
                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {

                    Text("Period")
                        .font(.system(size: 14, weight: .medium))

                    Picker(
                        "Period",
                        selection: $selectedPeriod
                    ) {

                        ForEach(
                            periods,
                            id: \.self
                        ) { period in

                            Text(period)
                                .tag(period)
                        }
                    }
                    .pickerStyle(.menu)
                }

                // Search button
                Button {

                    // API integration will be added later

                } label: {

                    Text("Search")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.themeOrange)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SearchView()
}

