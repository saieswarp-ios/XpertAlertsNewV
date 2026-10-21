//
//  AlertDefinitionRepository.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

protocol AlertDefinitionRepository {

    func getAlertDefinitions(
        applicationId: Int,
        alertFlag: Int,
        sessionId: String
    ) async throws -> [AlertDefinition]
}
