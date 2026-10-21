//
//  DeleteForwardAlertUserUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/10/26.
//


import Foundation

final class DeleteForwardAlertUserUseCase {

    private let repository: ForwardAlertsRepository

    init(
        repository: ForwardAlertsRepository
    ) {
        self.repository = repository
    }

    func execute(
        forwardAlertId: Int,
        sessionId: String
    ) async throws -> DeleteForwardAlertUserResponse {

        return try await repository.deleteForwardAlertUser(
            forwardAlertId: forwardAlertId,
            sessionId: sessionId
        )
    }
}
