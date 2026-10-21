//
//  SaveSubscriptionUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

final class SaveSubscriptionUseCase {

    private let repository: SubscriptionRepository

    init(repository: SubscriptionRepository) {
        self.repository = repository
    }

    func execute(
        userSubId: Int,
        alertName: String,
        applicationId: String,
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

        return try await repository.saveSubscription(
            userSubId: userSubId,
            alertName: alertName,
            applicationId: Int(applicationId) ?? 0, 
            alertDefId: alertDefId,
            userId: userId,
            alertTypes: alertTypes,
            mailId: mailId,
            messageBody: messageBody,
            subject: subject,
            alertFlag: alertFlag,
            threshold: threshold,
            sortOrder: sortOrder,
            active: active,
            sessionId: sessionId
        )
    }
}
