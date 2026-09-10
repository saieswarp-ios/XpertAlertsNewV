//
//  AlertsViewModel.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/09/26.
//

import SwiftUI
import Combine  

@MainActor

final class AlertsViewModel: ObservableObject {
        
    @Published var alerts: [Alert] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getAlertsUseCase: GetAlertsUseCase
    
    init(getAlertsUseCase: GetAlertsUseCase) {
        self.getAlertsUseCase = getAlertsUseCase
    }
    
    func loadAlerts() {
        errorMessage = nil
        isLoading = true
        
        Task {
            
            
            do {
                let formatter = DateFormatter()
                formatter.dateFormat =  "MM/dd/yyyy"
                let today = Date()
                let startDate = Calendar.current.date(
                    
                    byAdding: .day, value: -3, to: today
                    
                )!
                
                print("Start Date:", formatter.string(from: startDate))
                print("End Date:", formatter.string(from: today))
                
                let result = try await getAlertsUseCase.execute(
                    
                    startDate: "",
                    endDate: "",
                    searchByKeyword: "",
                    viewByFlag: 0,
                    applicationId: 0,
                    alertDefinitionId: 0
                    
                )
                alerts = result
                
                
            }
            
            
            catch {
                
                print("failed to load Alerts:", error)
                
                errorMessage = "Unable To Load Alerts."
            }
            isLoading = false
        }
        
        
        
    }
    
}
