//
//  SearchAlertsViewModel.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/10/26.
//


import Foundation
import Combine

@MainActor
final class SearchAlertsViewModel: ObservableObject {

    @Published var applications: [Application] = []
    @Published var alertDefinitions: [AlertDefinition] = []

    @Published var selectedApplicationId: Int = 0

    // Old UIKit Alert Definition dropdown: 0, 1, or 2
    @Published var selectedViewByFlag: Int = 0

    // ID selected from the definitions returned by the API
    @Published var selectedAlertDefinitionId: Int = 0

    @Published var startDate: Date = Calendar.current.date(
        byAdding: .day,
        value: -3,
        to: Date()
    ) ?? Date()

    @Published var endDate: Date = Date()
    @Published var keyword: String = ""

    @Published var isLoading = false
    @Published var errorMessage: String?
    private(set) var isRestoringFilters = false

    private let getApplicationsUseCase: GetApplicationsUseCase
    private let getAlertDefinitionsUseCase: GetAlertDefinitionsUseCase
    private let userRepository: UserRepository

    init(
        getApplicationsUseCase: GetApplicationsUseCase,
        getAlertDefinitionsUseCase: GetAlertDefinitionsUseCase,
        userRepository: UserRepository
    ) {
        self.getApplicationsUseCase = getApplicationsUseCase
        self.getAlertDefinitionsUseCase = getAlertDefinitionsUseCase
        self.userRepository = userRepository
    }

    func loadApplications() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            applications = try await getApplicationsUseCase.execute()
        } catch {
            errorMessage = "Unable to load applications."
            print("Failed to load applications:", error)
        }
    }

    func loadAlertDefinitions(applicationId: Int) async {
        alertDefinitions = []
        selectedAlertDefinitionId = 0

        guard applicationId > 0 else {
            return
        }

        guard let user = userRepository.getUser() else {
            errorMessage = "User session not found. Please sign in again."
            return
        }

        do {
            alertDefinitions = try await getAlertDefinitionsUseCase.execute(
                applicationId: applicationId,
                alertFlag: 1,
                sessionId: user.sessionId
            )
            
        } catch {
            errorMessage = "Unable to load alert definitions."
            print("Failed to load alert definitions:", error)
        }
    }

    func resetFilters() {
        startDate = Calendar.current.date(
            byAdding: .day,
            value: -3,
            to: Date()
        ) ?? Date()

        endDate = Date()
        keyword = ""
        selectedApplicationId = 0
        selectedViewByFlag = 0
        selectedAlertDefinitionId = 0
        alertDefinitions = []
        errorMessage = nil
    }
    
    
    func restoreFilters(_ filters: AlertSearchFilters) async {
        isRestoringFilters = true
        defer {
            isRestoringFilters = false
        }

        startDate = filters.startDate
        endDate = filters.endDate
        keyword = filters.keyword
        selectedViewByFlag = filters.viewByFlag
        selectedApplicationId = filters.applicationId

        if filters.applicationId > 0 {
            await loadAlertDefinitions(
                applicationId: filters.applicationId
            )
            selectedAlertDefinitionId = filters.alertDefinitionId
        } else {
            alertDefinitions = []
            selectedAlertDefinitionId = 0
        }
    }

}
