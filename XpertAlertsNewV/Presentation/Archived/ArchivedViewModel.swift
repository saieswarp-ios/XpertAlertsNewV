
import SwiftUI
import Combine

@MainActor
final class ArchivedViewModel: ObservableObject {

    @Published var alerts: [Alert] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getArchivedAlertsUseCase: GetArchivedAlertsUseCase

    init(getArchivedAlertsUseCase: GetArchivedAlertsUseCase) {
        self.getArchivedAlertsUseCase = getArchivedAlertsUseCase
    }

    func loadArchivedAlerts(filters: ArchivedSearchFilters? = nil) {
        errorMessage = nil
        isLoading = true

        Task {
            defer {
                isLoading = false
            }

            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone.current

                let startDateString: String
                let endDateString: String
                let keyword: String
                let viewBy: Int
                let deviceStatus: Int
                let emailStatus: Int

                if let filters {
                    // Match the old iOS app:
                    // send the selected filter IDs directly.
                    startDateString = formatter.string(
                        from: filters.startDate
                    )

                    endDateString = formatter.string(
                        from: filters.endDate
                    )

                    keyword = filters.keyword
                    viewBy = filters.viewByFlag
                    deviceStatus = filters.deviceStatus
                    emailStatus = filters.emailStatus

               
                } else {
                    // Initial load: match the old iOS request behavior.
                    startDateString = "10/23/2024"
                    endDateString = "10/26/2026"
                    keyword = ""
                    viewBy = 0
                    deviceStatus = 0
                    emailStatus = 0
                }

                

                print("ARCHIVED FILTERS:")
                print("Start Date: \(startDateString)")
                print("End Date: \(endDateString)")
                print("Keyword: \(keyword)")
                print("View By: \(viewBy)")
                print("Device Status: \(deviceStatus)")
                print("Email Status: \(emailStatus)")

                let result = try await getArchivedAlertsUseCase.execute(
                    startDate: startDateString,
                    endDate: endDateString,
                    searchByKeyword: keyword,
                    viewByFlag: viewBy,
                    status: deviceStatus,
                    emailStatus: emailStatus
                )

                alerts = result

                print("Returned Alerts: \(result.count)")
                print("Archived Results: \(result.count)")

            } catch {
                print("Failed to load archived alerts:", error)
                errorMessage = "Unable To Load Archived Alerts."
            }
        }
    }
}

