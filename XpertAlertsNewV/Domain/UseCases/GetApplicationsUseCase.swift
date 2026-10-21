
//  Untitled.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 24/09/26.
//

import Foundation

final class GetApplicationsUseCase {

    private let applicationRepository: ApplicationRepository

    init(applicationRepository: ApplicationRepository) {
        self.applicationRepository = applicationRepository
    }

    func execute() async throws -> [Application] {
        try await applicationRepository.getApplications()
    }
}
