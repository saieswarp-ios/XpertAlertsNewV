//
//  ApplicationRepositoryImpl.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 24/09/26.
//

import Foundation

final class ApplicationRepositoryImpl: ApplicationRepository {

    private let apiClient: APIClient
    private let userRepository: UserRepository

    init(
        apiClient: APIClient,
        userRepository: UserRepository
    ) {
        self.apiClient = apiClient
        self.userRepository = userRepository
    }

    func getApplications() async throws -> [Application] {

        guard let user = userRepository.getUser() else {
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint =
            APIEndpoint.baseURL +
            APIEndpoint.applications

        let queryItems = [
            URLQueryItem(
                name: "userId",
                value: String(user.userId)
            ),
            URLQueryItem(
                name: "userTypeId",
                value: String(user.userTypeId)
            ),
            URLQueryItem(
                name: "sessionId",
                value: user.sessionId
            )
        ]

        print("APPLICATION API:", endpoint)
        print("Application User ID:", user.userId)
        print("Application User Type ID:", user.userTypeId)
        print("Application Session ID:", user.sessionId)

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        print("RAW APPLICATION RESPONSE:")
        print(
            String(data: data, encoding: .utf8)
            ?? "Unable to read response"
        )

        let response =
            try JSONDecoder().decode(
                [ApplicationResponse].self,
                from: data
            )

        print("Number of Applications:", response.count)

        return response.compactMap { item in

            guard
                let id = item.id,
                let name = item.name
            else {
                return nil
            }

            return Application(
                id: id,
                name: name
            )
        }
    }
}
