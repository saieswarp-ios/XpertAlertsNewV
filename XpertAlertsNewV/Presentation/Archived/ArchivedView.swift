

import SwiftUI

struct ArchivedView: View {
    @StateObject private var viewModel: ArchivedViewModel
    let coordinator: AppCoordinator

    @State private var searchText = ""

    init(
        container: DIContainer,
        coordinator: AppCoordinator
    ) {
        self.coordinator = coordinator
        _viewModel = StateObject(
            wrappedValue: container.makeArchivedViewModel()
        )
    }

    private var filteredAlerts: [Alert] {
        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            return viewModel.alerts
        }

        return viewModel.alerts.filter { alert in
            alert.subject.localizedCaseInsensitiveContains(query) ||
            alert.message.localizedCaseInsensitiveContains(query) ||
            alert.applicationName.localizedCaseInsensitiveContains(query)
        }
    }

    private var groupedAlerts: [(date: String, alerts: [Alert])] {
        let groups = Dictionary(grouping: filteredAlerts) { alert in
            Self.dayLabel(from: alert.groupBy, fallback: alert.date)
        }

        // Preserve the order of dates as they first appear in the API response.
        var seen = Set<String>()
        var orderedGroups: [(date: String, alerts: [Alert])] = []

        for alert in filteredAlerts {
            let key = Self.dayLabel(
                from: alert.groupBy,
                fallback: alert.date
            )

            guard seen.insert(key).inserted else { continue }

            if let alerts = groups[key] {
                orderedGroups.append((date: key, alerts: alerts))
            }
        }

        return orderedGroups
    }

    var body: some View {
        VStack(spacing: 0) {
            AppScreenHeader(
                title: "Archived",
                subtitle: nil,
                icon: "archivebox.fill"
            )
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)

            searchBar

            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading archived alerts...")
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()

                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.themeOrange)

                    Text(errorMessage)
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }

                Spacer()
            } else if filteredAlerts.isEmpty {
                Spacer()

                VStack(spacing: 10) {
                    Image(systemName: "archivebox")
                        .font(.system(size: 32))
                        .foregroundStyle(.secondary)

                    Text(
                        searchText.isEmpty
                            ? "No Archived Alerts"
                            : "No Matching Alerts"
                    )
                    .font(.system(size: 17, weight: .medium))

                    Text(
                        searchText.isEmpty
                            ? "There are no archived alerts to display."
                            : "Try a different search term."
                    )
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                }

                Spacer()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 14) {
                        ForEach(
                            Array(groupedAlerts.enumerated()),
                            id: \.offset
                        ) { _, group in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(group.date)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 5)
                                    .background(
                                        Color.themeOrange,
                                        in: Capsule()
                                    )

                                LazyVStack(spacing: 10) {
                                    ForEach(group.alerts) { alert in
                                        ArchivedRow(
                                            title: alert.subject,
                                            message: alert.message,
                                            application: alert.applicationName,
                                            date: alert.date
                                        ) {
                                            coordinator.showAlertDetails(alert)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(Color.white)
        .onAppear {
            let filters = coordinator.pendingArchivedSearchFilters
            coordinator.pendingArchivedSearchFilters = nil
            viewModel.loadArchivedAlerts(filters: filters)
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)

            TextField("Search Archived Alerts", text: $searchText)
                .font(.system(size: 14))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .disabled(true)

            Spacer(minLength: 0)

            Image(systemName: "magnifyingglass")
                .font(.system(size: 17))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 14)
        .frame(height: 42)
        .background(Color.white, in: Capsule())
        .overlay {
            Capsule()
                .stroke(Color.gray.opacity(0.20), lineWidth: 1)
        }
        .contentShape(Capsule())
        .onTapGesture {
            coordinator.showArchivedSearch()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    private static func dayLabel(
        from groupBy: String,
        fallback date: String
    ) -> String {
        let rawValue = groupBy.isEmpty ? date : groupBy

        let formats = [
            "MM/dd/yyyy",
            "MM/dd/yyyy hh:mm a",
            "MM/dd/yyyy hh:mm:ss a",
            "yyyy-MM-dd"
        ]

        for format in formats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = .current
            formatter.dateFormat = format

            if let parsedDate = formatter.date(from: rawValue) {
                let output = DateFormatter()
                output.locale = Locale.current
                output.timeZone = .current
                output.dateFormat = "dd MMM"
                return output.string(from: parsedDate)
            }
        }

        return rawValue
    }
}

struct ArchivedRow: View {
    let title: String
    let message: String
    let application: String
    let date: String
    let action: () -> Void

    private var parsedDate: Date? {
        let formats = [
            "MM/dd/yyyy hh:mm a",
            "MM/dd/yyyy hh:mm:ss a",
            "MM/dd/yyyy"
        ]

        for format in formats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = .current
            formatter.dateFormat = format

            if let parsed = formatter.date(from: date) {
                return parsed
            }
        }

        return nil
    }

    private var displayDay: String {
        guard let parsedDate else { return date }

        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: parsedDate)
    }

    private var displayTime: String {
        guard let parsedDate else { return "" }

        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: parsedDate)
    }

    private var preview: String {
        let source = message.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = source.isEmpty ? title : source

        return content
            .replacingOccurrences(
                of: "(?i)<br\\s*/?>",
                with: " ",
                options: .regularExpression
            )
            .replacingOccurrences(
                of: "<[^>]+>",
                with: "",
                options: .regularExpression
            )
            .replacingOccurrences(
                of: "&nbsp;",
                with: " ",
                options: .caseInsensitive
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                VStack(spacing: 4) {
                    Text(displayDay)
                        .lineLimit(1)

                    Text(displayTime)
                        .lineLimit(1)
                }
                .font(.system(size: 11))
                .foregroundStyle(Color.gray)
                .frame(width: 56)

                Rectangle()
                    .fill(Color.themeOrange)
                    .frame(width: 1, height: 38)

                VStack(alignment: .leading, spacing: 3) {
                    Text(preview)
                        .font(.system(size: 11))
                        .foregroundStyle(Color.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(application)
                        .font(.system(size: 10))
                        .foregroundStyle(Color.gray.opacity(0.9))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(
                Color(red: 0.95, green: 0.95, blue: 0.97),
                in: RoundedRectangle(cornerRadius: 6)
            )
        }
        .buttonStyle(.plain)
    }
}
