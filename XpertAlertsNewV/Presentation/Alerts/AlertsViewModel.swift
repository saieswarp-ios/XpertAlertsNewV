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
    private let getSearchApplicationUseCase: GetSearchApplicationUseCase
        
    
    init(
        getAlertsUseCase: GetAlertsUseCase,
        getSearchApplicationUseCase: GetSearchApplicationUseCase
    ) {
        self.getAlertsUseCase = getAlertsUseCase
        self.getSearchApplicationUseCase =
            getSearchApplicationUseCase
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
                    
                    startDate: formatter.string(from: startDate),
                    endDate: formatter.string(from: today),
                    searchByKeyword: "",
                    viewByFlag: 0,
                    applicationId: getSearchApplicationUseCase.execute(),
                        
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
