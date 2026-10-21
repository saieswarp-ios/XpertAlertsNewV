//
//  ArchivedRepositoryImpl.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 25/09/26.
//

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

        print(
            "ARCHIVED API:",
            endpoint
        )

        print(
            "Archived User ID:",
            user.userId
        )

        print(
            "Archived Session ID:",
            user.sessionId
        )

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

        print("archived Api response received")

        print("RAW ARCHIVED RESPONSE:")

        print(
            String(
                data: data,
                encoding: .utf8
            ) ?? "Unable to read response"
        )

        let response =
            try JSONDecoder().decode(
                [AlertResponse].self,
                from: data
            )

        print(
            "Number of Archived Alerts:",
            response.count
        )

        let alerts =
            response.compactMap { item -> Alert? in

                guard
                    let id = item.id,
                    let alertId = item.alertId,
                    let alertDefId = item.alertDefId,
                    let userId = item.userId,
                    let applicationId = item.applicationId,
                    let subject = item.subject,
                    let message = item.message,
                    let date = item.alertSendDate,
                    let applicationName = item.applicationName,
                    let userName = item.userName,
                    let groupBy = item.groupBy,
                    let aggregateAlertId =
                        item.aggregateAlertId,
                    let count = item.count,
                    let status = item.status
                else {
                    return nil
                }

                return Alert(
                    id: id,
                    alertId: alertId,
                    alertDefId: alertDefId,
                    userid: userId,
                    applicationId: applicationId,
                    subject: subject,
                    message: message,
                    date: date,
                    applicationName: applicationName,
                    username: userName,
                    groupBy: groupBy,
                    aggregateAlertId: aggregateAlertId,
                    count: count,
                    status: status
                )
            }

        return alerts
    }
}
