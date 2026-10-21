//
//  GetForwardApplicationsUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 28/09/26.
//

import Foundation

struct GetForwardApplicationsUseCase {

    private let repository: ForwardAlertsRepository

    init(repository: ForwardAlertsRepository) {
        self.repository = repository
    }

    func execute() async throws -> [ForwardApplication] {
        try await repository.getApplications()
    }
}
