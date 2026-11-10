
import SwiftUI

// MARK: - Archived Search Filters

struct ArchivedSearchFilters {

    var keyword: String
    var startDate: Date
    var endDate: Date
    var viewByFlag: Int
    var deviceStatus: Int
    var emailStatus: Int
}

// MARK: - Archived Search View

struct ArchivedSearchView: View {

    @ObservedObject var coordinator: AppCoordinator

    @State private var keyword = ""

    @State private var startDate = Calendar.current.date(
        byAdding: .day,
        value: -3,
        to: Date()
    ) ?? Date()

    @State private var endDate = Date()

    @State private var viewByFlag = 0
    @State private var deviceStatus = 0
    @State private var emailStatus = 0

    @State private var showDateError = false

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            // MARK: Header

            HStack(spacing: 12) {

                Button {
                    coordinator.showArchived()
                } label: {

                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.themeOrange)
                        .frame(width: 36, height: 36)
                }

                Text("Search Archived Alerts")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.themeOrange)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)

            Divider()

            // MARK: Search Fields

            ScrollView {

                VStack(alignment: .leading, spacing: 18) {

                    // Date Range

                    sectionTitle("Date Range")

                    VStack(spacing: 12) {

                        dateField(
                            title: "Start Date",
                            date: $startDate,
                            range: ...endDate
                        )

                        dateField(
                            title: "End Date",
                            date: $endDate,
                            range: startDate...
                        )
                    }

                    // Keyword

                    sectionTitle("Search Keyword")

                    TextField(
                        "Enter keyword",
                        text: $keyword
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 14)
                    .frame(height: 46)
                    .background(Color(.systemGray6))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )

                    // View By

                    sectionTitle("View By")

                    customPicker(
                        title: "Select View By",
                        selection: $viewByFlag,
                        options: [
                            (0, "Select"),
                            (1, "Alert Definition"),
                            (2, "Application")
                        ]
                    )

                    // Device Status

                    sectionTitle("Device Status")

                    customPicker(
                        title: "Select Device Status",
                        selection: $deviceStatus,
                        options: [
                            (0, "Select Device Status"),
                            (1, "New Alert"),
                            (2, "Delivered"),
                            (3, "Dismissed"),
                            (4, "Action Taken"),
                            (5, "Unsubscribed"),
                            (6, "Notification Off")
                        ]
                    )

                    // Email Status

                    sectionTitle("Email Status")

                    customPicker(
                        title: "Select Email Status",
                        selection: $emailStatus,
                        options: [
                            (0, "Select Email Status"),
                            (1, "Ready To Send"),
                            (2, "Email Sent"),
                            (3, "Notification Off"),
                            (4, "Failed Mail")
                        ]
                    )

                    // Buttons

                    HStack(spacing: 12) {

                        Button {
                            searchArchivedAlerts()
                        } label: {

                            Label(
                                "Search",
                                systemImage: "magnifyingglass"
                            )
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(Color.themeOrange)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                        }

                        Button {
                            resetFilters()
                        } label: {

                            Text("Reset")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color.themeOrange)
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .background(Color.white)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            Color.themeOrange,
                                            lineWidth: 1
                                        )
                                }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 18)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden(true)

        // MARK: Date Validation Alert

        .alert(
            "Invalid Date Range",
            isPresented: $showDateError
        ) {

            Button("OK", role: .cancel) {}

        } message: {

            Text("The end date must be on or after the start date.")
        }
    }

    // MARK: - Section Title

    private func sectionTitle(_ title: String) -> some View {

        Text(title)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.primary)
    }

    // MARK: - Date Field

    private func dateField(
        title: String,
        date: Binding<Date>,
        range: PartialRangeThrough<Date>
    ) -> some View {

        HStack {

            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(.primary)

            Spacer()

            DatePicker(
                "",
                selection: date,
                in: range,
                displayedComponents: .date
            )
            .labelsHidden()
            .tint(Color.themeOrange)
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background(Color(.systemGray6))
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
    }

    private func dateField(
        title: String,
        date: Binding<Date>,
        range: PartialRangeFrom<Date>
    ) -> some View {

        HStack {

            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(.primary)

            Spacer()

            DatePicker(
                "",
                selection: date,
                in: range,
                displayedComponents: .date
            )
            .labelsHidden()
            .tint(Color.themeOrange)
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background(Color(.systemGray6))
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
    }

    // MARK: - Custom Dropdown

    private func customPicker(
        title: String,
        selection: Binding<Int>,
        options: [(Int, String)]
    ) -> some View {

        Menu {

            ForEach(options, id: \.0) { option in

                Button {
                    selection.wrappedValue = option.0
                } label: {

                    if selection.wrappedValue == option.0 {

                        Label(
                            option.1,
                            systemImage: "checkmark"
                        )

                    } else {

                        Text(option.1)
                    }
                }
            }

        } label: {

            HStack {

                Text(
                    options.first(where: {
                        $0.0 == selection.wrappedValue
                    })?.1 ?? title
                )
                .font(.system(size: 14))
                .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .frame(height: 46)
            .background(Color(.systemGray6))
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )
            .contentShape(
                RoundedRectangle(cornerRadius: 10)
            )
        }
    }

    // MARK: - Search Action

    private func searchArchivedAlerts() {

        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)

        guard start <= end else {
            showDateError = true
            return
        }

        let filters = ArchivedSearchFilters(
            keyword: keyword.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            startDate: startDate,
            endDate: endDate,
            viewByFlag: viewByFlag,
            deviceStatus: deviceStatus,
            emailStatus: emailStatus
        )

        coordinator.applyArchivedSearch(filters: filters)
    }

    // MARK: - Reset Filters

    private func resetFilters() {

        keyword = ""

        startDate = Calendar.current.date(
            byAdding: .day,
            value: -3,
            to: Date()
        ) ?? Date()

        endDate = Date()

        viewByFlag = 0
        deviceStatus = 0
        emailStatus = 0
    }
}

