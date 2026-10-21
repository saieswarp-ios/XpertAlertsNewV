//
//  GetAlertDefinitionsUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

final class GetAlertDefinitionsUseCase {

    private let alertDefinitionRepository:
        AlertDefinitionRepository

    init(
        alertDefinitionRepository:
            AlertDefinitionRepository
    ) {
        self.alertDefinitionRepository =
            alertDefinitionRepository
    }

    func execute(
        applicationId: Int,
        alertFlag: Int,
        sessionId: String
    ) async throws -> [AlertDefinition] {

        return try await alertDefinitionRepository
            .getAlertDefinitions(
                applicationId: applicationId,
                alertFlag: alertFlag,
                sessionId: sessionId
            )
    }
}
