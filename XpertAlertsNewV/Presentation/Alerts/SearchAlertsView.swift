
import SwiftUI

struct SearchAlertsView: View {

    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel: SearchAlertsViewModel
    @State private var showDateError = false

    init(
        container: DIContainer,
        coordinator: AppCoordinator
    ) {
        self.coordinator = coordinator
        _viewModel = StateObject(
            wrappedValue: container.makeSearchAlertsViewModel()
        )
    }

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Header

            HStack(spacing: 12) {

                Button {
                    coordinator.showAlerts()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.themeOrange)
                        .frame(width: 28, height: 40)
                }
                .buttonStyle(.plain)

                Text("Search Alerts")
                    .font(.avenirBold(size: 21))
                    .foregroundStyle(Color.themeOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 4)

                // Reset Button - Top Right

                Button {
                    viewModel.resetFilters()
                    coordinator.savedAlertSearchFilters = nil
                    coordinator.pendingAlertSearchFilters = nil
                } label: {
                    Text("Reset")
                        .font(.avenirDemiBold(size: 14))
                        .foregroundStyle(Color.themeOrange)
                        .frame(height: 40)
                        .padding(.horizontal, 12)
                        .background(Color.themeOrange.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.themeOrange.opacity(0.5),
                                    lineWidth: 1
                                )
                        }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // MARK: - Search Form

            Form {

                Section("Date Range") {

                    DatePicker(
                        "Start Date",
                        selection: $viewModel.startDate,
                        displayedComponents: .date
                    )

                    DatePicker(
                        "End Date",
                        selection: $viewModel.endDate,
                        displayedComponents: .date
                    )
                }

                Section("Search Keyword") {

                    TextField(
                        "Enter keyword",
                        text: $viewModel.keyword
                    )
                    .textInputAutocapitalization(.never)
                }

                // MARK: - Alert Definition

                Section("Alert Definition") {

                    Picker(
                        "Select Alert Definition",
                        selection: $viewModel.selectedViewByFlag
                    ) {
                        Text("Select Alert Definition")
                            .tag(0)

                        Text("Alert Definition")
                            .tag(1)

                        Text("Application")
                            .tag(2)
                    }
                }

                // MARK: - Application

                Section("Application") {

                    Picker(
                        "Select Application",
                        selection: $viewModel.selectedApplicationId
                    ) {
                        Text("All Applications")
                            .tag(0)

                        ForEach(viewModel.applications) { application in
                            Text(application.name)
                                .tag(application.id)
                        }
                    }
                }

                // MARK: - Email Sent

                Section("Email Sent") {

                    Picker(
                        "Select Email Sent",
                        selection: $viewModel.selectedAlertDefinitionId
                    ) {
                        Text("Select Email Sent")
                            .tag(0)

                        ForEach(viewModel.alertDefinitions) { definition in
                            Text(definition.name)
                                .tag(definition.id)
                        }
                    }
                    .disabled(viewModel.selectedApplicationId == 0)
                }

                if viewModel.isLoading {

                    Section {
                        HStack {
                            Spacer()
                            ProgressView("Loading...")
                            Spacer()
                        }
                    }
                }

                if let errorMessage = viewModel.errorMessage {

                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                // MARK: - Search Button

                Section {

                    Button {

                        let start = Calendar.current.startOfDay(
                            for: viewModel.startDate
                        )

                        let end = Calendar.current.startOfDay(
                            for: viewModel.endDate
                        )

                        if start > end {

                            showDateError = true

                        } else {

                            let filters = AlertSearchFilters(
                                startDate: viewModel.startDate,
                                endDate: viewModel.endDate,
                                keyword: viewModel.keyword,
                                applicationId: viewModel.selectedApplicationId,
                                viewByFlag: viewModel.selectedViewByFlag,
                                alertDefinitionId: viewModel.selectedAlertDefinitionId
                            )

                            coordinator.applyAlertSearch(filters: filters)
                        }

                    } label: {

                        HStack {
                            Spacer()

                            Image(systemName: "magnifyingglass")

                            Text("Search")
                                .font(.avenirDemiBold(size: 16))

                            Spacer()
                        }
                    }
//                    .foregroundStyle(.white)
//                    .listRowBackground(Color.themeOrange)
                    .foregroundStyle(Color.white)
                    .listRowBackground(Color.themeOrange)
                
                  
}
            }
        }
        .background(Color(.systemGroupedBackground))

        .task {
            await viewModel.loadApplications()

            if let filters = coordinator.savedAlertSearchFilters {
                await viewModel.restoreFilters(filters)
            }
        }

        .onChange(of: viewModel.selectedApplicationId) { newValue in

            guard !viewModel.isRestoringFilters else {
                return
            }

            viewModel.selectedAlertDefinitionId = 0

            Task {
                await viewModel.loadAlertDefinitions(
                    applicationId: newValue
                )
            }
        }

        .alert("Invalid Date Range", isPresented: $showDateError) {

            Button("OK", role: .cancel) {}

        } message: {

            Text("The end date must be on or after the start date.")
        }
    }
}

