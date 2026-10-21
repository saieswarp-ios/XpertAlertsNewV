import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel: SearchViewModel
    
    let coordinator: AppCoordinator
    
    @State private var selectedApplication = "Applications"
    @State private var selectedPeriod = "Today"
    
    let applications = [
        "Applications",
        "Production",
        "Server Monitor",
        "Backup Service"
    ]
    
    let periods = [
        "Today",
        "Last 3 Days",
        "Last 7 Days",
        "Last 30 Days"
    ]
    init(
        container: DIContainer,
        coordinator: AppCoordinator
    ) {
        self.coordinator = coordinator
        
        _viewModel = StateObject(
            wrappedValue:
                container.makeSearchViewModel()
        )
    }
    var body: some View {
        
        ScrollView {
            
            VStack(
                alignment: .leading,
                spacing: 18
            ) {
                
                AppScreenHeader(
                    title: "Search",
                    subtitle: nil,
                    icon: "magnifyingglass"
                )
                
                // MARK: - Search By
                
                VStack(
                    alignment: .leading,
                    spacing: 7
                ) {
                    
                    Text("Search By")
                        .font(
                            .system(
                                size: 14,
                                weight: .medium
                            )
                        )
                    
                    TextField(
                        "Search Alerts",
                        text:
                            $viewModel.searchByKeyword
                    )
                    .textFieldStyle(.roundedBorder)
                }
                
                // MARK: - Period
                
                VStack(
                    alignment: .leading,
                    spacing: 7
                ) {
                    
                    Text("Period")
                        .font(
                            .system(
                                size: 14,
                                weight: .medium
                            )
                        )
                    
                    Picker(
                        "Period",
                        selection:
                            $selectedPeriod
                    ) {
                        
                        ForEach(
                            periods,
                            id: \.self
                        ) { period in
                            
                            Text(period)
                                .tag(period)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // MARK: - Application
                
                VStack(
                    alignment: .leading,
                    spacing: 7
                ) {
                    
                    Text("Application")
                        .font(
                            .system(
                                size: 14,
                                weight: .medium
                            )
                        )
                    
                    Picker(
                        "Application",
                        selection:
                            $selectedApplication
                    ) {
                        
                        ForEach(
                            applications,
                            id: \.self
                        ) { application in
                            
                            Text(application)
                                .tag(application)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(
                        of: selectedApplication
                    ) { _, newValue in
                        
                        switch newValue {
                            
                        case "Production":
                            
                            viewModel.selectApplication(4)
                            
                        default:
                            
                            viewModel.selectApplication(0)
                        }
                    }
                }
                
                // MARK: - Search Button
                
                Button {
                    
                    viewModel.applySearch(
                        period:
                            selectedPeriod
                    )
                    
                } label: {
                    
                    if viewModel.isLoading {
                        
                        ProgressView()
                            .tint(.white)
                        
                    } else {
                        
                        Text("Search")
                            .frame(
                                maxWidth: .infinity
                            )
                    }
                }
                .buttonStyle(
                    .borderedProminent
                )
                .tint(.themeOrange)
                .disabled(
                    viewModel.isLoading
                )
                
                // MARK: - Error
                
                if let errorMessage =
                    viewModel.errorMessage {
                    
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundStyle(.red)
                }
                
                // MARK: - Results
                
                if !viewModel.alerts.isEmpty {
                    
                    VStack(
                        alignment: .leading,
                        spacing: 0
                    ) {
                        
                        Text("Results")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .medium
                                )
                            )
                            .padding(.bottom, 8)
                        
                        ForEach(viewModel.alerts) { alert in
                            
                            Button {
                                coordinator.showAlertDetails(alert)
                            } label: {
                                
                                VStack(
                                    alignment: .leading,
                                    spacing: 6
                                ) {
                                    
                                    HStack {
                                        
                                        Text(alert.subject)
                                            .font(
                                                .system(
                                                    size: 16,
                                                    weight: .medium
                                                )
                                            )
                                            .foregroundStyle(.primary)
                                        
                                        Spacer()
                                        
                                        Text(alert.date)
                                            .font(
                                                .system(size: 12)
                                            )
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Text(alert.message)
                                        .font(
                                            .system(size: 14)
                                        )
                                        .foregroundStyle(.primary)
                                    
                                    Text(alert.applicationName)
                                        .font(
                                            .system(size: 12)
                                        )
                                        .foregroundStyle(.secondary)
                                }
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(.plain)
                            
                            Divider()
                        }
                    }
                }
            }
        }
    }
}
