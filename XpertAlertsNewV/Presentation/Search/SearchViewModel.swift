//
//  SearchViewModel.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 10/09/26.
//

import SwiftUI
import Combine
@MainActor

final class SearchViewModel : ObservableObject {
    
    @Published var selectedApplicationId: Int = 0
    
    @Published var startDate = ""
    @Published var endDate = ""
    @Published var searchByKeyword = ""
    let applications: [Int] = [0, 4]
    
    private let saveSearchApplicationUseCase:
        SaveSearchApplicationUseCase

    private let getSearchApplicationUseCase:
        GetSearchApplicationUseCase

    private let saveSearchDatesUseCase:
        SaveSearchDatesUseCase

    private let getSearchDatesUseCase:
        GetSearchDatesUseCase
    
    init(
        saveSearchApplicationUseCase:
            SaveSearchApplicationUseCase,

        getSearchApplicationUseCase:
            GetSearchApplicationUseCase,

        saveSearchDatesUseCase:
            SaveSearchDatesUseCase,

        getSearchDatesUseCase:
            GetSearchDatesUseCase
    ) {

        self.saveSearchApplicationUseCase =
            saveSearchApplicationUseCase

        self.getSearchApplicationUseCase =
            getSearchApplicationUseCase

        self.saveSearchDatesUseCase =
            saveSearchDatesUseCase

        self.getSearchDatesUseCase =
            getSearchDatesUseCase

        loadSavedApplication()
    }
    
    func selectApplication(_ applicationId: Int) {
        
        selectedApplicationId = applicationId
        
        saveSearchApplicationUseCase.execute(
            applicationId: applicationId
        )
    }
    
    func applySearch() {
        saveSearchApplicationUseCase.execute(
            applicationId: selectedApplicationId
        )

        print(
            "Search applied. Application ID:",
            selectedApplicationId
        )
    }
    
    
    private func loadSavedApplication() {
        
        selectedApplicationId =
        getSearchApplicationUseCase.execute()
        
        print(
            "Loaded Application ID:",
            selectedApplicationId
        )
        
    }
}
