//
//  SubscriptionRepositoryImpl.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

final class SubscriptionRepositoryImpl: SubscriptionRepository {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    // MARK: - Get Subscriptions

    func getSubscriptions(
        userId: Int,
        applicationId: String,
        searchName: String,
        searchActive: Int,
        sessionId: String
    ) async throws -> [Subscription] {

        let endpoint =
            APIEndpoint.baseURL +
            APIEndpoint.subscriptions

        print(
            "GET SUBSCRIPTIONS API:",
            endpoint
        )

        let queryItems = [

            URLQueryItem(
                name: "userId",
                value: String(userId)
            ),

            URLQueryItem(
                name: "lowerBound",
                value: "0"
            ),

            URLQueryItem(
                name: "upperBound",
                value: "100"
            ),

            URLQueryItem(
                name: "searchName",
                value: searchName
            ),

            URLQueryItem(
                name: "applicationId",
                value: String(applicationId)
            ),

            URLQueryItem(
                name: "searchActive",
                value: String(searchActive)
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
                [Subscription].self,
                from: data
            )

        return response
    }

    // MARK: - Get Subscription Details

    func getSubscriptionDetails(
        subscriptionId: Int,
        sessionId: String
    ) async throws -> SubscriptionDetails {

        let endpoint =
            APIEndpoint.baseURL +
            APIEndpoint.subscriptionDetails

        print(
            "GET SUBSCRIPTION DETAILS API:",
            endpoint
        )

        let queryItems = [

            URLQueryItem(
                name: "userSubId",
                value: String(subscriptionId)
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

        print(
            "RAW SUBSCRIPTION DETAILS RESPONSE:"
        )

        print(
            String(data: data, encoding: .utf8)
            ?? "Unable to read response"
        )

        let response =
            try JSONDecoder().decode(
                [SubscriptionDetails].self,
                from: data
            )

        guard let result = response.first else {

            throw NSError(
                domain: "SubscriptionRepository",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Subscription details response is empty."
                ]
            )
        }

        return result
    }

    // MARK: - Check Duplicate Subscription

    func checkDuplicateSubscription(
        userId: Int,
        applicationId: Int,
        alertDefinitionId: Int,
        alertFlag: Int,
        userSubId: Int,
        sessionId: String
    ) async throws -> DuplicateSubscriptionResponse {

        let endpoint =
            APIEndpoint.baseURL +
            APIEndpoint.checkDuplicateSubscription

        print(
            "CHECK DUPLICATE SUBSCRIPTION API:",
            endpoint
        )

        let queryItems = [

            URLQueryItem(
                name: "userId",
                value: String(userId)
            ),

            URLQueryItem(
                name: "applicationId",
                value: String(applicationId)
            ),

            URLQueryItem(
                name: "alertDefinitionId",
                value: String(alertDefinitionId)
            ),

            URLQueryItem(
                name: "alertFlag",
                value: String(alertFlag)
            ),

            URLQueryItem(
                name: "userSubId",
                value: String(userSubId)
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
                [DuplicateSubscriptionResponse].self,
                from: data
            )

        guard let result = response.first else {

            throw NSError(
                domain: "SubscriptionRepository",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Duplicate subscription response is empty."
                ]
            )
        }

        return result
    }

    // MARK: - Save Subscription

    func saveSubscription(
        userSubId: Int,
        alertName: String,
        applicationId: Int,
        alertDefId: Int,
        userId: Int,
        alertTypes: Int,
        mailId: String,
        messageBody: String,
        subject: String,
        alertFlag: Int,
        threshold: Int,
        sortOrder: Int,
        active: Int,
        sessionId: String
    ) async throws -> SaveSubscriptionResponse {

        let endpoint =
            APIEndpoint.baseURL +
            APIEndpoint.saveSubscription

        print(
            "SAVE SUBSCRIPTION API:",
            endpoint
        )

        let queryItems = [

            URLQueryItem(
                name: "userSubId",
                value: String(userSubId)
            ),

            URLQueryItem(
                name: "alertName",
                value: alertName
            ),

            URLQueryItem(
                name: "applicationId",
                value: String(applicationId)
            ),

            URLQueryItem(
                name: "alertDefId",
                value: String(alertDefId)
            ),

            URLQueryItem(
                name: "userId",
                value: String(userId)
            ),

            URLQueryItem(
                name: "alertTypes",
                value: String(alertTypes)
            ),

            URLQueryItem(
                name: "mailId",
                value: mailId
            ),

            URLQueryItem(
                name: "messageBody",
                value: messageBody
            ),

            URLQueryItem(
                name: "subject",
                value: subject
            ),

            URLQueryItem(
                name: "alertFlag",
                value: String(alertFlag)
            ),

            URLQueryItem(
                name: "threshold",
                value: String(threshold)
            ),

            URLQueryItem(
                name: "sortOrder",
                value: String(sortOrder)
            ),

            URLQueryItem(
                name: "active",
                value: String(active)
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

        print(
            "RAW SAVE SUBSCRIPTION RESPONSE:"
        )

        print(
            String(data: data, encoding: .utf8)
            ?? "Unable to read response"
        )

        let response =
            try JSONDecoder().decode(
                [SaveSubscriptionResponse].self,
                from: data
            )

        guard let result = response.first else {

            throw NSError(
                domain: "SubscriptionRepository",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Save subscription response is empty."
                ]
            )
        }

        return result
    }
}
