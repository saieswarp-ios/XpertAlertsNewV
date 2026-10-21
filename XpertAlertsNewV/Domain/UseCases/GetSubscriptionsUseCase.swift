//
//  GetSubscriptionsUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

final class GetSubscriptionsUseCase {

    private let repository: SubscriptionRepository

    init(repository: SubscriptionRepository) {
        self.repository = repository
    }

   
    func execute(
        userId: Int,
        applicationId: String,
        searchName: String = "",
        searchActive: Int = 1,
        sessionId: String
    ) async throws -> [Subscription] {

        return try await repository.getSubscriptions(
            userId: userId,
            applicationId: applicationId,
            searchName: searchName,
            searchActive: searchActive,
            sessionId: sessionId
        )
    }
  
}
