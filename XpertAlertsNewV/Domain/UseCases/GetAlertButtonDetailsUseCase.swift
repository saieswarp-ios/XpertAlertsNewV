//
//  GetAlertButtonDetailsUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/10/26.
//


import Foundation

final class GetAlertButtonDetailsUseCase {

    private let alertRepository: AlertRepository

    init(alertRepository: AlertRepository) {
        self.alertRepository = alertRepository
    }

    func execute(
        applicationId: Int,
        alertDefinitionId: Int
    ) async throws -> [GetAlertButtonDetailsResponse] {

        return try await alertRepository.getAlertButtonDetails(
            applicationId: applicationId,
            alertDefinitionId: alertDefinitionId
        )
    }
}

