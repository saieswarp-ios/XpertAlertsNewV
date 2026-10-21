//
//  GetForwardAlertsUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 29/09/26.
//

import Foundation

struct GetForwardAlertsUseCase {

    private let repository: ForwardAlertsRepository

    init(repository: ForwardAlertsRepository) {
        self.repository = repository
    }

    func execute() async throws -> [ForwardAlert] {
        try await repository.getForwardAlerts()
    }
}
