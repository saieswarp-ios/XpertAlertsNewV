//
//  GetDuplicateSubscriptionUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

final class GetDuplicateSubscriptionUseCase {

    private let repository: SubscriptionRepository

    init(repository: SubscriptionRepository) {
        self.repository = repository
    }

    func execute(
        userId: Int,
        applicationId: Int,
        alertDefinitionId: Int,
        alertFlag: Int,
        userSubId: Int,
        sessionId: String
    ) async throws -> DuplicateSubscriptionResponse {

        return try await repository.checkDuplicateSubscription(
            userId: userId,
            applicationId: applicationId,
            alertDefinitionId: alertDefinitionId,
            alertFlag: alertFlag,
            userSubId: userSubId,
            sessionId: sessionId
        )
    }
}
