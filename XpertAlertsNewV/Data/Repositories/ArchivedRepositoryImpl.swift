
import Foundation

final class ArchivedRepositoryImpl: ArchivedRepository {

    private let apiClient: APIClient
    private let userRepository: UserRepository

    init(
        apiClient: APIClient,
        userRepository: UserRepository
    ) {
        self.apiClient = apiClient
        self.userRepository = userRepository
    }

    func getArchivedAlerts(
        startDate: String,
        endDate: String,
        searchByKeyword: String,
        viewByFlag: Int,
        status: Int,
        emailStatus: Int
    ) async throws -> [Alert] {

        guard let user = userRepository.getUser() else {
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint =
            APIEndpoint.baseURL +
            APIEndpoint.archivedAlerts

        print("ARCHIVED API:", endpoint)
        print("Archived User ID:", user.userId)

        // Do not print the session ID because it is sensitive.

        let queryItems = [
            URLQueryItem(
                name: "userId",
                value: String(user.userId)
            ),
            URLQueryItem(
                name: "startDate",
                value: startDate
            ),
            URLQueryItem(
                name: "endDate",
                value: endDate
            ),
            URLQueryItem(
                name: "searchByKeyword",
                value: searchByKeyword
            ),
            URLQueryItem(
                name: "viewByFlag",
                value: String(viewByFlag)
            ),
            URLQueryItem(
                name: "status",
                value: String(status)
            ),
            URLQueryItem(
                name: "emailStatus",
                value: String(emailStatus)
            ),
            URLQueryItem(
                name: "sessionId",
                value: user.sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        print("Archived API response received")

        print("RAW ARCHIVED RESPONSE:")
        print(
            String(data: data, encoding: .utf8)
                ?? "Unable to read response"
        )

        let response = try JSONDecoder().decode(
            [AlertResponse].self,
            from: data
        )

        print("Number of Archived Alerts:", response.count)

     
        let alerts = response.compactMap { item -> Alert? in

            // Archived API records use archiveId, not necessarily id.
            guard
                let id = item.id ?? item.archiveId,
                let alertId = item.alertId,
                let alertDefId = item.alertDefId,
                let userId = item.userId,
                let applicationId = item.applicationId,
                let subject = item.subject,
                let date = item.alertSendDate,
                let applicationName = item.applicationName,
                let userName = item.userName,
                let groupBy = item.groupBy,
                let count = item.count,
                let status = item.status
            else {
                print("Skipping archived item: missing essential fields")
                return nil
            }

            return Alert(
                id: id,
                alertId: alertId,
                alertDefId: alertDefId,
                userid: userId,
                applicationId: applicationId,
                subject: subject,
                message: item.message ?? "",
                date: date,
                applicationName: applicationName,
                username: userName,
                groupBy: groupBy,
                aggregateAlertId: item.aggregateAlertId ?? "",
                count: count,
                status: status
            )
        }

        print("DECODED ARCHIVED ITEMS:", response.count)
        print("MAPPED ARCHIVED ALERTS:", alerts.count)

        return alerts


        
    }
}

