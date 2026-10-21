//
//  ChangePasswordRepositoryImpl.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

final class ChangePasswordRepositoryImpl: ChangePasswordRepository {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func changePassword(
        username: String,
        oldPassword: String,
        newPassword: String,
        userId: Int
    ) async throws -> ChangePasswordResponse {

        let endpoint =
            APIEndpoint.baseURL +
            APIEndpoint.changePassword

        print("CHANGE PASSWORD API:", endpoint)

        let queryItems = [

            URLQueryItem(
                name: "username",
                value: username
            ),

            URLQueryItem(
                name: "oldPwd",
                value: oldPassword
            ),

            URLQueryItem(
                name: "newPwd",
                value: newPassword
            ),

            URLQueryItem(
                name: "userId",
                value: String(userId)
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        let response =
            try JSONDecoder().decode(
                [ChangePasswordResponse].self,
                from: data
            )

        guard let firstResponse = response.first else {
            throw URLError(.cannotParseResponse)
        }

        return firstResponse
    }
}
