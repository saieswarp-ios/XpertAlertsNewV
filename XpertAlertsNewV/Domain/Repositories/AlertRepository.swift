//
//  AlertRepository.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/09/26.
//
import Foundation

protocol AlertRepository {
    
    func getAlerts(
        
        startDate: String,
        endDate: String,
        searchByKeyword: String,
        viewByFlag: Int,
        applicationId: Int,
        alertDefinitionId: Int
        
        
    ) async throws -> [Alert]
    
    // Fetch available alert button details
       func getAlertButtonDetails(
           applicationId: Int,
           alertDefinitionId: Int
       ) async throws -> [GetAlertButtonDetailsResponse]
    
    func processDynamicActions(
        applicationId: Int,
        id: Int,
        alertId: Int,
        aggregateAlertIds: String,
        actionId: String,
        caption: String
    ) async throws -> [ProcessDynamicActionsResponse]
   }

