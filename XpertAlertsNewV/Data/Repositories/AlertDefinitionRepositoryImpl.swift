//
//  AlertDefinitionRepositoryImpl.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

final class AlertDefinitionRepositoryImpl:
    AlertDefinitionRepository {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func getAlertDefinitions(
        applicationId: Int,
        alertFlag: Int,
        sessionId: String
    ) async throws -> [AlertDefinition] {

        let endpoint =
            APIEndpoint.baseURL +
            APIEndpoint.alertDefinitions

        print(
            "ALERT DEFINITION API:",
            endpoint
        )

        let queryItems = [

            URLQueryItem(
                name: "applicationId",
                value: String(applicationId)
            ),

            URLQueryItem(
                name: "alertFlag",
                value: String(alertFlag)
            ),

            URLQueryItem(
                name: "sessionId",
                value: sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        let response =
            try JSONDecoder().decode(
                [ApplicationResponse].self,
                from: data
            )

        return response.compactMap { item in

            guard
                let id = item.id,
                let name = item.name
            else {
                return nil
            }

            return AlertDefinition(
                id: id,
                name: name
            )
        }
    }
}
