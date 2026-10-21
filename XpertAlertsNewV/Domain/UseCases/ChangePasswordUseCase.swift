//
//  ChangePasswordUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

final class ChangePasswordUseCase {

    private let repository: ChangePasswordRepository

    init(repository: ChangePasswordRepository) {
        self.repository = repository
    }

    func execute(
        username: String,
        oldPassword: String,
        newPassword: String,
        userId: Int
    ) async throws -> ChangePasswordResponse {

        return try await repository.changePassword(
            username: username,
            oldPassword: oldPassword,
            newPassword: newPassword,
            userId: userId
        )
    }
}
