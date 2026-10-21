//
//  ArchivedViewModel.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 25/09/26.
//

import SwiftUI
import Combine

@MainActor
final class ArchivedViewModel:
    ObservableObject {

    @Published var alerts: [Alert] = []

    @Published var isLoading = false

    @Published var errorMessage: String?

    private let getArchivedAlertsUseCase:
        GetArchivedAlertsUseCase

    init(
        getArchivedAlertsUseCase:
            GetArchivedAlertsUseCase
    ) {
        self.getArchivedAlertsUseCase =
            getArchivedAlertsUseCase
    }

    func loadArchivedAlerts() {

        errorMessage = nil
        isLoading = true

        Task {

            do {

                let formatter =
                    DateFormatter()

                formatter.dateFormat =
                    "MM/dd/yyyy"

                let today = Date()

                let startDate =
                    Calendar.current.date(
                        byAdding: .day,
                        value: -30,
                        to: today
                    )!

                let result =
                    try await
                    getArchivedAlertsUseCase.execute(

                        startDate:
                            formatter.string(
                                from: startDate
                            ),

                        endDate:
                            formatter.string(
                                from: today
                            ),

                        searchByKeyword: "",

                        viewByFlag: 0,

                        status: 0,

                        emailStatus: 0
                    )

                alerts = result

                print(
                    "Archived Results:",
                    result.count
                )

            } catch {

                print(
                    "Failed to load archived alerts:",
                    error
                )

                errorMessage =
                    "Unable To Load Archived Alerts."

            }

            isLoading = false
        }
    }
}
