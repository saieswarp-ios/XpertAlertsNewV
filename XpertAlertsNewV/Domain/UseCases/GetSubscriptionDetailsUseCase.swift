//
//  GetSubscriptionDetailsUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

final class GetSubscriptionDetailsUseCase {

    private let repository: SubscriptionRepository

    init(repository: SubscriptionRepository) {
        self.repository = repository
    }

    func execute(
        subscriptionId: Int,
        sessionId: String
    ) async throws -> SubscriptionDetails {

        return try await repository.getSubscriptionDetails(
            subscriptionId: subscriptionId,
            sessionId: sessionId
        )
    }
}
