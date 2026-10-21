//
//  SearchViewModel.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 10/09/26.
//
import SwiftUI
import Combine

@MainActor
final class SearchViewModel: ObservableObject {

    // MARK: - Search Values

    @Published var selectedApplicationId: Int = 0
    @Published var startDate = ""
    @Published var endDate = ""
    @Published var searchByKeyword = ""

    // MARK: - Search Result

    @Published var alerts: [Alert] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    let applications: [Int] = [0, 4]

    // MARK: - Use Cases

    private let saveSearchApplicationUseCase:
        SaveSearchApplicationUseCase

    private let getSearchApplicationUseCase:
        GetSearchApplicationUseCase

    private let saveSearchDatesUseCase:
        SaveSearchDatesUseCase

    private let getSearchDatesUseCase:
        GetSearchDatesUseCase

    private let getAlertsUseCase:
        GetAlertsUseCase

    // MARK: - Init

    init(
        saveSearchApplicationUseCase:
            SaveSearchApplicationUseCase,

        getSearchApplicationUseCase:
            GetSearchApplicationUseCase,

        saveSearchDatesUseCase:
            SaveSearchDatesUseCase,

        getSearchDatesUseCase:
            GetSearchDatesUseCase,

        getAlertsUseCase:
            GetAlertsUseCase
    ) {

        self.saveSearchApplicationUseCase =
            saveSearchApplicationUseCase

        self.getSearchApplicationUseCase =
            getSearchApplicationUseCase

        self.saveSearchDatesUseCase =
            saveSearchDatesUseCase

        self.getSearchDatesUseCase =
            getSearchDatesUseCase

        self.getAlertsUseCase =
            getAlertsUseCase

        loadSavedApplication()
    }

    // MARK: - Application

    func selectApplication(_ applicationId: Int) {

        selectedApplicationId = applicationId

        saveSearchApplicationUseCase.execute(
            applicationId: applicationId
        )
    }

    // MARK: - Search

    func applySearch(
        period: String
    ) {

        errorMessage = nil
        isLoading = true

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"

        let today = Date()

        let startDate: Date

        switch period {

        case "Last 3 Days":

            startDate = Calendar.current.date(
                byAdding: .day,
                value: -3,
                to: today
            )!

        case "Last 7 Days":

            startDate = Calendar.current.date(
                byAdding: .day,
                value: -7,
                to: today
            )!

        case "Last 30 Days":

            startDate = Calendar.current.date(
                byAdding: .day,
                value: -30,
                to: today
            )!

        default:

            startDate = today
        }

        let formattedStartDate =
            formatter.string(from: startDate)

        let formattedEndDate =
            formatter.string(from: today)

        self.startDate = formattedStartDate
        self.endDate = formattedEndDate

        saveSearchApplicationUseCase.execute(
            applicationId:
                selectedApplicationId
        )

        saveSearchDatesUseCase.execute(
            startDate:
                formattedStartDate,
            endDate:
                formattedEndDate
        )

        print(
            "Search Start Date:",
            formattedStartDate
        )

        print(
            "Search End Date:",
            formattedEndDate
        )

        print(
            "Search Application ID:",
            selectedApplicationId
        )

        print(
            "Search Keyword:",
            searchByKeyword
        )

        Task {

            do {

                let result =
                    try await getAlertsUseCase.execute(
                        startDate:
                            formattedStartDate,

                        endDate:
                            formattedEndDate,

                        searchByKeyword:
                            searchByKeyword,

                        viewByFlag: 0,

                        applicationId:
                            selectedApplicationId,

                        alertDefinitionId: 0
                    )

                alerts = result

                print(
                    "Search Results:",
                    result.count
                )

            } catch {

                print(
                    "Search failed:",
                    error
                )

                errorMessage =
                    "Unable To Search Alerts."

            }

            isLoading = false
        }
    }

    // MARK: - Saved Application

    private func loadSavedApplication() {

        selectedApplicationId =
            getSearchApplicationUseCase.execute()

        print(
            "Loaded Application ID:",
            selectedApplicationId
        )
    }
}
