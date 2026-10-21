//
//  GetForwardUsersUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 28/09/26.
//

import Foundation

struct GetForwardUsersUseCase {

    private let repository: ForwardAlertsRepository

    init(repository: ForwardAlertsRepository) {
        self.repository = repository
    }

    func execute(applicationId: Int?) async throws -> [ForwardUser] {
        try await repository.getUsers(applicationId: applicationId)
    }
}
