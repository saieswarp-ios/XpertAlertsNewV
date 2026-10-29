
import SwiftUI

struct AlertsView: View {

    @StateObject private var viewModel: AlertsViewModel
    let coordinator: AppCoordinator

    init(
        container: DIContainer,
        coordinator: AppCoordinator
    ) {
        self.coordinator = coordinator
        _viewModel = StateObject(
            wrappedValue: container.makeAlertsViewModel()
        )
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header

            AppScreenHeader(
                title: "Alerts",
                subtitle: nil,
                icon: "bell.fill"
            )
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)

            // MARK: - Search Alerts

            Button {
                coordinator.showSearchAlerts()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                    Text("Search Alerts")
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .background(Color.themeOrange)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.bottom, 10)

            Divider()

            // MARK: - Loading State

            if viewModel.isLoading && viewModel.alerts.isEmpty {

                Spacer()
                ProgressView("Loading alerts...")
                Spacer()

            // MARK: - Error State

            } else if viewModel.alerts.isEmpty,
                      let errorMessage = viewModel.errorMessage {

                Spacer()

                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.themeOrange)

                    Text(errorMessage)
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Retry") {
                        viewModel.loadAlerts()
                    }
                    .foregroundStyle(Color.themeOrange)
                }
                .padding(16)

                Spacer()

            // MARK: - Empty State

            } else if viewModel.alerts.isEmpty {

                Spacer()

                VStack(spacing: 10) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 32))
                        .foregroundStyle(.secondary)

                    Text("No Alerts")
                        .font(.system(size: 17, weight: .medium))

                    Text("There are no alerts to display for this date range.")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(16)

                Spacer()

            // MARK: - Date-Grouped Alerts

            } else {

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {

                        ForEach(groupedAlerts, id: \.dateKey) { group in

                            // Date heading

                            Text(group.dateTitle)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .frame(height: 29)
                                .background(Color.themeOrange)
                                .clipShape(Capsule())
                                .padding(.leading, 16)
                                .padding(.top, 10)
                                .padding(.bottom, 7)

                            // Alerts belonging to this date

                            ForEach(group.alerts) { alert in
                                Button {
                                    coordinator.showAlertDetails(alert)
                                } label: {
                                    LegacyAlertCard(
                                        title: alert.subject,
                                        message: alert.message,
                                        date: alert.date
                                    )
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 9)
                            }
                        }
                    }
                    .padding(.bottom, 12)
                }
                .refreshable {
                    await viewModel.refreshAlerts()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            if let filters = coordinator.pendingAlertSearchFilters {
                coordinator.pendingAlertSearchFilters = nil
                viewModel.searchAlerts(filters: filters)
            } else if viewModel.alerts.isEmpty && !viewModel.isLoading {
                viewModel.loadAlerts()
            }
        }
        .onChange(of: coordinator.refreshAlertsAfterAction) { _, needsRefresh in
            guard needsRefresh else { return }
            coordinator.refreshAlertsAfterAction = false
            Task {
                await viewModel.refreshAlerts()
            }
        }
    }

    // MARK: - Group Alerts Using API groupBy

    private var groupedAlerts: [AlertDateGroup] {

        let groups = Dictionary(
            grouping: viewModel.alerts,
            by: { $0.groupBy }
        )

        return groups.map { key, alerts in

            let parsedGroupDate = Self.parseDate(key)

            let dateTitle: String

            if let parsedGroupDate {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd MMM"
                dateTitle = formatter.string(from: parsedGroupDate)
            } else {
                dateTitle = key
            }

            let sortedAlerts = alerts.sorted { first, second in
                let firstDate = Self.parseDate(first.date) ?? .distantPast
                let secondDate = Self.parseDate(second.date) ?? .distantPast

                return firstDate > secondDate
            }

            return AlertDateGroup(
                dateKey: key,
                dateTitle: dateTitle,
                sortDate: parsedGroupDate ?? .distantPast,
                alerts: sortedAlerts
            )
        }
        .sorted { $0.sortDate > $1.sortDate }
    }

    // MARK: - Date Parsing

    private static func parseDate(_ value: String) -> Date? {

        let formats = [
            "MM/dd/yyyy hh:mm:ss a",
            "MM/dd/yyyy hh:mm a",
            "MM/dd/yyyy HH:mm:ss",
            "MM/dd/yyyy HH:mm",
            "MM/dd/yyyy"
        ]

        for format in formats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = .current
            formatter.dateFormat = format

            if let parsedDate = formatter.date(from: value) {
                return parsedDate
            }
        }

        return ISO8601DateFormatter().date(from: value)
    }
}

// MARK: - Date Group

private struct AlertDateGroup {
    let dateKey: String
    let dateTitle: String
    let sortDate: Date
    let alerts: [Alert]
}

// MARK: - Old-Style Alert Card

private struct LegacyAlertCard: View {

    let title: String
    let message: String
    let date: String

    // MARK: - Parse Alert Date

    private var parsedAlertDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM/dd/yyyy hh:mm a"
        return formatter.date(from: date)
    }

    // MARK: - Display Date

    private var displayDate: String {
        guard let parsedAlertDate else {
            return date
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MM/dd/yyyy hh:mm a"

        return formatter.string(from: parsedAlertDate)
    }

    // MARK: - Display Time

    private var displayTime: String {
        guard let parsedAlertDate else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "hh:mm a"

        return formatter.string(from: parsedAlertDate)
    }

    // MARK: - Clean HTML Message

    
    // MARK: - Clean HTML Message

    private var formattedMessage: String {
        var cleaned = message

        // Replace HTML line breaks and paragraph tags with spaces
        cleaned = cleaned.replacingOccurrences(
            of: "(?i)<br\\s*/?>|</?p\\b[^>]*>",
            with: " ",
            options: .regularExpression
        )

        // Remove remaining HTML tags, including <B>, </B>, etc.
        cleaned = cleaned.replacingOccurrences(
            of: "<[^>]*>",
            with: "",
            options: .regularExpression
        )

        // Decode common HTML entities
        let replacements: [(String, String)] = [
            ("&nbsp;", " "),
            ("&#160;", " "),
            ("&amp;", "&"),
            ("&lt;", "<"),
            ("&gt;", ">"),
            ("&quot;", "\""),
            ("&#39;", "'"),
            ("&apos;", "'")
        ]

        for (html, plainText) in replacements {
            cleaned = cleaned.replacingOccurrences(
                of: html,
                with: plainText,
                options: .caseInsensitive
            )
        }

        // Remove extra spaces
        return cleaned
            .replacingOccurrences(
                of: "\\s+",
                with: " ",
                options: .regularExpression
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    

    // MARK: - Card UI

    var body: some View {
        HStack(spacing: 0) {

            // Left column: date and time

            VStack(spacing: 5) {

                Text(
                    parsedAlertDate.map { value in
                        let formatter = DateFormatter()
                        formatter.locale = Locale(identifier: "en_US")
                        formatter.dateFormat = "dd MMM"
                        return formatter.string(from: value)
                    } ?? title
                )
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)

                Text(displayTime.isEmpty ? displayDate : displayTime)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(width: 78)
            .padding(.vertical, 10)

            // Orange vertical divider

            Rectangle()
                .fill(Color.themeOrange)
                .frame(width: 1, height: 36)

            // Right column: message

            Text(formattedMessage.isEmpty ? title : formattedMessage)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                .padding(.trailing, 8)
                .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 58)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow(
            color: .black.opacity(0.08),
            radius: 2,
            x: 0,
            y: 1
        )
        .contentShape(Rectangle())
    }
}

