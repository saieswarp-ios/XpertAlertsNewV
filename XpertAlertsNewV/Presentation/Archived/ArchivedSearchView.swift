//
//  ArchivedSearchView.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 23/10/26.
//

import SwiftUI

struct ArchivedSearchFilters {
    var keyword: String
    var startDate: Date
    var endDate: Date
    var viewByFlag: Int
    var deviceStatus: Int
    var emailStatus: Int
}

struct ArchivedSearchView: View {
    let coordinator: AppCoordinator

    @State private var keyword = ""
    @State private var startDate = Calendar.current.date(
        byAdding: .day,
        value: -3,
        to: Date()
    ) ?? Date()
    @State private var endDate = Date()

    @State private var viewByFlag = 0
    @State private var deviceStatus = 0
    @State private var emailStatus = 0

    private let orange = Color.themeOrange

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    coordinator.showArchived()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                }

                Text("Search Archived List")
                    .font(.system(size: 20, weight: .semibold))

                Spacer()

                Button("Reset") {
                    resetFilters()
                }
                .foregroundStyle(orange)
            }
            .padding()

            Form {
                Section("Search") {
                    TextField("Search keyword", text: $keyword)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section("Date Range") {
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        in: ...endDate,
                        displayedComponents: .date
                    )

                    DatePicker(
                        "End Date",
                        selection: $endDate,
                        in: startDate...,
                        displayedComponents: .date
                    )
                }

                Section("View By") {
                    Picker("View By", selection: $viewByFlag) {
                        Text("Select").tag(0)
                        Text("Alert Definition").tag(1)
                        Text("Application").tag(2)
                    }
                }

                Section("Device Status") {
                    Picker("Device Status", selection: $deviceStatus) {
                        Text("Select Device Status").tag(0)
                        Text("New Alert").tag(1)
                        Text("Delivered").tag(2)
                        Text("Dismissed").tag(3)
                        Text("Action Taken").tag(4)
                        Text("Unsubscribed").tag(5)
                        Text("Notification Off").tag(6)
                    }
                }

                Section("Email Status") {
                    Picker("Email Status", selection: $emailStatus) {
                        Text("Select Email Status").tag(0)
                        Text("Ready To Send").tag(1)
                        Text("Email Sent").tag(2)
                        Text("Notification Off").tag(3)
                        Text("Failed Mail").tag(4)
                    }
                }

                Section {
                    Button {
                        let filters = ArchivedSearchFilters(
                            keyword: keyword.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            startDate: startDate,
                            endDate: endDate,
                            viewByFlag: viewByFlag,
                            deviceStatus: deviceStatus,
                            emailStatus: emailStatus
                        )

                        coordinator.applyArchivedSearch(filters: filters)
                    } label: {
                        Text("Search")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                    }
                    .listRowBackground(orange)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func resetFilters() {
        keyword = ""
        startDate = Calendar.current.date(
            byAdding: .day,
            value: -3,
            to: Date()
        ) ?? Date()
        endDate = Date()
        viewByFlag = 0
        deviceStatus = 0
        emailStatus = 0
    }
}

