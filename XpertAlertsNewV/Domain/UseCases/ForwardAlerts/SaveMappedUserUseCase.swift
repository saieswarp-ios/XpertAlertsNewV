//
//  SaveMappedUserUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/10/26.
//
import Foundation

final class SaveMappedUserUseCase {

    private let repository: ForwardAlertsRepository

    init(
        repository: ForwardAlertsRepository
    ) {
        self.repository = repository
    }

    func execute(
        mappedUserId: Int,
        applicationId: Int,
        email: String,
        sortOrder: Int,
        active: Int
    ) async throws -> SaveMappedUserResponse {

        return try await repository.saveMappedUser(
            mappedUserId: mappedUserId,
            applicationId: applicationId,
            email: email,
            sortOrder: sortOrder,
            active: active
        )
    }
}
