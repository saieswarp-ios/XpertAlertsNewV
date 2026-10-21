//
//  DuplicateForwardAlertUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/10/26.
//

import Foundation

final class DuplicateForwardAlertUseCase {

    private let repository: ForwardAlertsRepository

    init(
        repository: ForwardAlertsRepository
    ) {
        self.repository = repository
    }

    func execute(
        forwardAlertId: Int,
        mappedUserId: Int,
        applicationId: Int,
        sessionId: String
    ) async throws -> DuplicateForwardAlertResponse {

        return try await repository.duplicateForwardAlert(
            forwardAlertId: forwardAlertId,
            mappedUserId: mappedUserId,
            applicationId: applicationId,
            sessionId: sessionId
        )
    }
}
