//
//  ProcessDynamicActionsUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/10/26.
//


import Foundation

final class ProcessDynamicActionsUseCase {

    private let alertRepository: AlertRepository

    init(alertRepository: AlertRepository) {
        self.alertRepository = alertRepository
    }

    func execute(
        applicationId: Int,
        id: Int,
        alertId: Int,
        aggregateAlertIds: String,
        actionId: String,
        caption: String
    ) async throws -> [ProcessDynamicActionsResponse] {

        return try await alertRepository.processDynamicActions(
            applicationId: applicationId,
            id: id,
            alertId: alertId,
            aggregateAlertIds: aggregateAlertIds,
            actionId: actionId,
            caption: caption
        )
    }
}
