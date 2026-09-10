//
//  GetAlertsUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/09/26.
//

import Foundation

final class GetAlertsUseCase {
    
    private let alertRepository: AlertRepository
    
    init(alertRepository: AlertRepository) {
        self.alertRepository = alertRepository
    }
    
    
    func execute(
        
        startDate: String,
        endDate: String,
        searchByKeyword: String,
        viewByFlag: Int,
        applicationId: Int,
        alertDefinitionId: Int
    ) async throws -> [Alert] {
        
        return try await alertRepository.getAlerts(
            
            startDate: startDate,
            endDate: endDate,
            searchByKeyword: searchByKeyword,
            viewByFlag: viewByFlag,
            applicationId: applicationId,
            alertDefinitionId: alertDefinitionId    
            
        )
            
    }
    
    
}

