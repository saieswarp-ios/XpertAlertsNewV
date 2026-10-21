//
//  AlertRepositoryImpl.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/09/26.
//

import Foundation

final class AlertRepositoryImpl: AlertRepository {

    
    private let apiClient: APIClient
    private let userRepository: UserRepository
    
    init(apiClient: APIClient, userRepository: UserRepository) {
        self.apiClient = apiClient
        self.userRepository = userRepository
    }
    
    func getAlerts(
        startDate: String,
        endDate: String,
        searchByKeyword: String,
        viewByFlag: Int,
        applicationId: Int,
        alertDefinitionId: Int
        
    ) async throws -> [Alert] {
        guard let user = userRepository.getUser() else {
            throw URLError(.userAuthenticationRequired)
        }
      
        let endpoint = APIEndpoint.baseURL + APIEndpoint.alerts
        
        print("Alert User ID:", user.userId)
        print("Alert Session ID:", user.sessionId)
        
        let queryItems = [
            
            URLQueryItem(name: "userId", value: String(user.userId)),
            URLQueryItem(name: "startDate", value: startDate),
            URLQueryItem(name: "endDate", value: endDate),
            URLQueryItem(name: "searchByKeyword", value: searchByKeyword),
            URLQueryItem(name: "viewByFlag", value: String(viewByFlag)),
            URLQueryItem(name: "applicationId", value: String(applicationId)),
            URLQueryItem(name: "alertDefinitionId", value: String(alertDefinitionId)),
            URLQueryItem(name: "sessionId", value: user.sessionId)
            
        ]
        
        print("Alert startDate:", startDate)
        print("Alert endDate:", endDate)
        print("Alert searchByKeyword:", searchByKeyword)
        print("Alert viewByFlag:", viewByFlag)
        print("Alert applicationId:", applicationId)
        print("Alert alertDefinitionId:", alertDefinitionId)
        
        
        let data = try await apiClient.request(endpoint: endpoint, method: "GET", queryItems: queryItems)
        
        print("alert Api response received")
        
        print("RAW ALERT RESPONSE:")
        print(String(data: data, encoding: .utf8) ?? "Unable to read response")
        
        let response = try JSONDecoder().decode([AlertResponse].self, from: data)
        
        print("Number of Alerts:", response.count)
        
        let alerts = response.compactMap { item -> Alert? in
            
            guard
                
                let id = item.id,
                let alertId = item.alertId,
                let alertDefId = item.alertDefId,
                let userId = item.userId,
                let applicationId = item.applicationId,
                let subject = item.subject,
                let message = item.message,
                let date = item.alertSendDate,
                let applicationName = item.applicationName,
                let userName = item.userName,
                let groupBy = item.groupBy,
             
                let count = item.count,
                let status = item.status
                    
            else {
               
              return nil
            }
           return Alert (id: id,
                         alertId: alertId,
                         alertDefId: alertDefId,
                         userid: userId,
                         applicationId: applicationId,
                         subject: subject,
                         message: message,
                         date: date,
                         applicationName: applicationName,
                         username: userName,
                         groupBy: groupBy,
                         aggregateAlertId: item.aggregateAlertId ?? "",
                         count: count,
                         status: status)
            
                
                
                
            
        }
        print("Mapped Alerts:", alerts.count)
        return alerts
        
       
    }
    
    

        func getAlertButtonDetails(
            applicationId: Int,
            alertDefinitionId: Int
        ) async throws -> [GetAlertButtonDetailsResponse] {

            guard let user = userRepository.getUser() else {
                throw URLError(.userAuthenticationRequired)
            }

            let endpoint = APIEndpoint.baseURL + APIEndpoint.alertButtonDetails

            let queryItems = [
                URLQueryItem(
                    name: "applicationId",
                    value: String(applicationId)
                ),
                URLQueryItem(
                    name: "alertDefId",
                    value: String(alertDefinitionId)
                ),
                URLQueryItem(
                    name: "sessionId",
                    value: user.sessionId
                ),
                URLQueryItem(
                    name: "userId",
                    value: String(user.userId)
                )
            ]

            let data = try await apiClient.request(
                endpoint: endpoint,
                method: "GET",
                queryItems: queryItems
            )

            print("RAW ALERT BUTTON DETAILS RESPONSE:")
            print(String(data: data, encoding: .utf8) ?? "Unable to read response")

            return try JSONDecoder().decode(
                [GetAlertButtonDetailsResponse].self,
                from: data
            )
        }
    
    
    
    func processDynamicActions(
        applicationId: Int,
        id: Int,
        alertId: Int,
        aggregateAlertIds: String,
        actionId: String,
        caption: String
    ) async throws -> [ProcessDynamicActionsResponse] {

        guard let user = userRepository.getUser() else {
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint = APIEndpoint.baseURL
            + APIEndpoint.processDynamicActions

        let queryItems = [
            URLQueryItem(
                name: "userId",
                value: String(user.userId)
            ),
            URLQueryItem(
                name: "applicationId",
                value: String(applicationId)
            ),
            URLQueryItem(
                name: "captions",
                value: caption
            ),
            URLQueryItem(
                name: "actions",
                value: "null"
            ),
            URLQueryItem(
                name: "amsActions",
                value: actionId
            ),
            URLQueryItem(
                name: "ids",
                value: String(id)
            ),
            URLQueryItem(
                name: "alertIds",
                value: String(alertId)
            ),
            URLQueryItem(
                name: "aggregateAlertIds",
                value: aggregateAlertIds
            ),
            URLQueryItem(
                name: "sessionId",
                value: user.sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        print("RAW PROCESS DYNAMIC ACTIONS RESPONSE:")
        print(
            String(data: data, encoding: .utf8)
                ?? "Unable to read response"
        )

        return try JSONDecoder().decode(
            [ProcessDynamicActionsResponse].self,
            from: data
        )
    }
  
}
