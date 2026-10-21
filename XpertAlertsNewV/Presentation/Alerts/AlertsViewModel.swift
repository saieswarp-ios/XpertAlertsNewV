
import SwiftUI
import Combine

@MainActor
final class AlertsViewModel: ObservableObject {
    var needsRefreshAfterAction = false
    @Published var alerts: [Alert] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private var lastSearchFilters: AlertSearchFilters?
    private let getAlertsUseCase: GetAlertsUseCase
    private let getSearchApplicationUseCase: GetSearchApplicationUseCase
    private let getAlertButtonDetailsUseCase: GetAlertButtonDetailsUseCase
    private let processDynamicActionsUseCase: ProcessDynamicActionsUseCase

    init(
        getAlertsUseCase: GetAlertsUseCase,
        getSearchApplicationUseCase: GetSearchApplicationUseCase,
        getAlertButtonDetailsUseCase: GetAlertButtonDetailsUseCase,
        processDynamicActionsUseCase: ProcessDynamicActionsUseCase
    ) {
        self.getAlertsUseCase = getAlertsUseCase
        self.getSearchApplicationUseCase = getSearchApplicationUseCase
        self.getAlertButtonDetailsUseCase = getAlertButtonDetailsUseCase
        self.processDynamicActionsUseCase = processDynamicActionsUseCase
    }

    // MARK: - Load Alerts

   
    // MARK: - Load Alerts

    func loadAlerts() {
        // Clear the previous error, but preserve existing alerts.
        errorMessage = nil
        isLoading = true

        Task { @MainActor in
            defer {
                isLoading = false
            }

            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"

                let today = Date()

                let startDate = Calendar.current.date(
                    byAdding: .day,
                    value: -3,
                    to: today
                ) ?? today

                let startDateString = formatter.string(from: startDate)
                let endDateString = formatter.string(from: today)

                print("Start Date:", startDateString)
                print("End Date:", endDateString)

                let result = try await getAlertsUseCase.execute(
                    startDate: startDateString,
                    endDate: endDateString,
                    searchByKeyword: "",
                    viewByFlag: 0,
                    applicationId: getSearchApplicationUseCase.execute(),
                    alertDefinitionId: 0
                )

                // Replace the existing list only after a successful response.
                alerts = result
                
                
                // Replace the existing list only after a successful response.
                alerts = result

                // TEMPORARY DEBUG LOGS
                print("Total alerts:", result.count)

                for alert in result.prefix(5) {
                    print("Date:", alert.date)
                    print("Group By:", alert.groupBy)
                    print("Subject:", alert.subject)
                    print("Message:", alert.message)
                }

                
                

            } catch {
                print("Failed to load Alerts:", error)

                // Keep the existing alerts visible if refresh fails.
                errorMessage = "Unable To Load Alerts."
            }
        }
    }

    
    
    
    func refreshAfterActionIfNeeded() {
        guard needsRefreshAfterAction else { return }

        needsRefreshAfterAction = false

        Task {
            await refreshAlerts()
        }
    }

    // MARK: - Load Alert Button Details

    func loadAlertButtonDetails(
        applicationId: Int,
        alertDefinitionId: Int
    ) async -> [GetAlertButtonDetailsResponse] {

        do {
            let response = try await getAlertButtonDetailsUseCase.execute(
                applicationId: applicationId,
                alertDefinitionId: alertDefinitionId
            )

            return response

        } catch {
            print("Failed to load alert button details:", error)
            errorMessage = "Unable to load alert button details."
            return []
        }
    }

    // MARK: - Process Dynamic Actions

    func processDynamicActions(
        applicationId: Int,
        id: Int,
        alertId: Int,
        aggregateAlertIds: String,
        actionId: String,
        caption: String
    ) async -> [ProcessDynamicActionsResponse] {

        do {
            let response = try await processDynamicActionsUseCase.execute(
                applicationId: applicationId,
                id: id,
                alertId: alertId,
                aggregateAlertIds: aggregateAlertIds,
                actionId: actionId,
                caption: caption
            )

            return response

        } catch {
            print("Failed to process dynamic action:", error)
            errorMessage = "Unable to process the selected action."
            return []
        }
    }
    
    
    
    func searchAlerts(filters: AlertSearchFilters) {
        
        lastSearchFilters = filters
        errorMessage = nil
        isLoading = true

        Task {
            defer {
                isLoading = false
            }

            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"

                let result = try await getAlertsUseCase.execute(
                    startDate: formatter.string(from: filters.startDate),
                    endDate: formatter.string(from: filters.endDate),
                    searchByKeyword: filters.keyword,
                    viewByFlag: filters.viewByFlag,
                    applicationId: filters.applicationId,
                    alertDefinitionId: filters.alertDefinitionId
                )

                alerts = result

                print("Filtered alerts loaded:", result.count)
            } catch {
                print("Failed to search Alerts:", error)
                errorMessage = "Unable To Load Alerts."
            }
        }
    }
    
    
    func searchAlerts(startDate: Date, endDate: Date) {
        let filters = AlertSearchFilters(
            startDate: startDate,
            endDate: endDate,
            keyword: "",
            applicationId: getSearchApplicationUseCase.execute(),
            viewByFlag: 0,
            alertDefinitionId: 0
        )

        searchAlerts(filters: filters)
    }
    func refreshAlerts() async {
        if let filters = lastSearchFilters {
            searchAlerts(filters: filters)
        } else {
            loadAlerts()
        }
    }

    
  
    func refreshAfterAction() async {
        await refreshAlerts()
    }
   
    
    
    
    }


