//
//  UpdateForwardAlertsUserStatusUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 08/10/26.
//

import Foundation

final class UpdateForwardAlertsUserStatusUseCase {

    private let repository: ForwardAlertsRepository

    init(
        repository: ForwardAlertsRepository
    ) {
        self.repository = repository
    }

    func execute(
        userId: Int,
        status: Int,
        mappedUserId: Int,
        applicationId: Int,
        sessionId: String
    ) async throws -> UpdateForwardAlertsUserStatusResponse {

        return try await repository.updateForwardAlertsUserStatus(
            userId: userId,
            status: status,
            mappedUserId: mappedUserId,
            applicationId: applicationId,
            sessionId: sessionId
        )
    }
}
