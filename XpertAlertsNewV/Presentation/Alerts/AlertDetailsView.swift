
import SwiftUI

struct AlertDetailsView: View {
    
    let alert: Alert
    let coordinator: AppCoordinator
    let container: DIContainer
    
    // MARK: - Alert Presentation
    
    private enum ActiveAlert: Identifiable {
        case confirmation
        case result
        
        var id: Int {
            switch self {
            case .confirmation: return 1
            case .result: return 2
            }
        }
    }
    
    // MARK: - State
    
    @State private var isLoadingActions = true
    @State private var alertButtonDetails: [GetAlertButtonDetailsResponse] = []
    
    @State private var actionOptions: [String] = []
    
    
    
    @State private var isActionsExpanded = false
    @State private var selectedAction = ""
    
    @State private var activeAlert: ActiveAlert?
    
    @State private var pendingActionId = ""
    @State private var pendingCaption = ""
    @State private var pendingPrompt = ""
    
    @State private var isProcessingAction = false
    @State private var actionResultMessage = ""
    
    @State private var shouldLogout = false
    @State private var shouldReturnToAlerts = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            HStack(spacing: 12) {
                Button {
                    coordinator.backToAlerts()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 36, height: 40)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                AppScreenHeader(
                    title: "Details",
                    subtitle: nil,
                    icon: "bell.badge.fill"
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Divider()
            
            // Alert information
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        sectionTitle("Subject")
                        
                        Text(alert.subject)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.primary)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        sectionTitle("Time")
                        
                        Text(alert.date)
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        sectionTitle("Message")
                        
                        Text(formattedMessage)
                            .font(.system(size: 15))
                            .foregroundStyle(.primary)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                    }
                    
                    // API-backed action dropdown
                    availableActionsSection
                    
                    if isProcessingAction {
                        HStack(spacing: 8) {
                            ProgressView()
                            
                            Text("Processing action...")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
        
        // Load the action details once for this screen.
        .task {
            await loadAlertActions()
        }
        
        // A single alert presenter handles confirmation and results.
        .alert(item: $activeAlert) { type in
            switch type {
                
            case .confirmation:
                return SwiftUI.Alert(
                    title: Text(
                        pendingPrompt.isEmpty
                        ? "Are you sure?"
                        : pendingPrompt
                    ),
                    primaryButton: .default(Text("OK")) {
                        Task {
                            await executeSelectedAction()
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel")) {
                        clearPendingAction()
                    }
                )
                
            case .result:
                return SwiftUI.Alert(
                    title: Text("Action Result"),
                    message: Text(actionResultMessage),
                    dismissButton: .default(Text("OK")) {
                        handleResultDismissal()
                    }
                )
            }
        }
    }
    
    // MARK: - Section Title
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color.themeOrange)
    }
    
    // MARK: - Available Actions
    
    
    private var availableActionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Available Actions")
            
            if isLoadingActions {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Loading actions...")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
                
            } else if actionOptions.isEmpty {
                Text("No actions available")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
                
            } else {
                ForEach(
                    Array(actionOptions.enumerated()),
                    id: \.offset
                ) { _, option in
                    Button {
                        selectAction(option)
                    } label: {
                        HStack {
                            Text(option)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color.themeOrange)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.gray.opacity(0.25),
                                    lineWidth: 1
                                )
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .disabled(isProcessingAction)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    
    private var dropdownTitle: String {
        if isLoadingActions {
            return "Loading actions..."
        }
        
        return actionOptions.isEmpty
        ? "No actions available"
        : "Select an action"
    }
    
    
    
    private var availableOptions: [String] {
        guard
            let details = alertButtonDetails.first,
            let captions = details.captions
                else {
            print("DEBUG: No action details or captions")
            return []
        }
        
        let options = captions
            .components(separatedBy: ",")
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .filter {
                !$0.isEmpty && $0.lowercased() != "null"
            }
        
        print("DEBUG: Parsed options:", options)
        return options
    }
    
    
    // MARK: - Load Actions
    
    
    
    
    @MainActor
    private func loadAlertActions() async {
        print("ACTIONS: Loading started")
        print("ACTIONS: applicationId =", alert.applicationId)
        print("ACTIONS: alertDefId =", alert.alertDefId)

        isLoadingActions = true

        let viewModel = container.makeAlertsViewModel()

        let result = await viewModel.loadAlertButtonDetails(
            applicationId: alert.applicationId,
            alertDefinitionId: alert.alertDefId
        )

        let captions = result.first?.captions ?? ""

        let options = captions
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty && $0.lowercased() != "null" }

        alertButtonDetails = result
        actionOptions = options

        // Always turn loading off when we finish (success or empty)
        isLoadingActions = false

        print("ACTIONS: Loading finished")
        print("ACTIONS: result count =", result.count)
        print("ACTIONS: captions =", captions)
        print("ACTIONS: options =", options)
    }
    
    // MARK: - Format Message
    
    private var formattedMessage: AttributedString {
        guard
            let data = alert.message.data(using: .utf8),
            let attributedString = try? NSAttributedString(
                data: data,
                options: [
                    .documentType:
                        NSAttributedString.DocumentType.html,
                    .characterEncoding:
                        String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
                else {
            return AttributedString(alert.message)
        }
        
        return AttributedString(attributedString)
    }
    
    // MARK: - Parse API Values
    
    private func splitValues(_ value: String?) -> [String] {
        guard
            let value,
            !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            value.lowercased() != "null"
                else {
            return []
        }
        
        return value
            .components(separatedBy: ",")
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .filter {
                !$0.isEmpty && $0.lowercased() != "null"
            }
    }
    
    // MARK: - Select Action
    
    private func selectAction(_ caption: String) {
        guard let details = alertButtonDetails.first else {
            return
        }
        
        let captions = splitValues(details.captions)
        let actionIDs = splitValues(details.AmsActionIds)
        let prompts = splitValues(details.confirmPrompt)
        
        guard
            let index = captions.firstIndex(of: caption),
            index < actionIDs.count
                else {
            print("Unable to match action:", caption)
            print("Captions:", captions)
            print("Action IDs:", actionIDs)
            return
        }
        
        // Close the inline dropdown before presenting confirmation.
        isActionsExpanded = false
        
        selectedAction = caption
        pendingCaption = caption
        pendingActionId = actionIDs[index]
        
        // Match the prompt to the selected action's position.
        pendingPrompt = index < prompts.count ? prompts[index] : ""
        
        print("Selected caption:", pendingCaption)
        print("Selected action ID:", pendingActionId)
        print("Selected prompt:", pendingPrompt)
        
        if pendingPrompt.isEmpty {
            Task {
                await executeSelectedAction()
            }
        } else {
            activeAlert = .confirmation
        }
    }
    
    // MARK: - Clear Pending Action
    
    private func clearPendingAction() {
        selectedAction = ""
        pendingActionId = ""
        pendingCaption = ""
        pendingPrompt = ""
    }
    
    // MARK: - Execute Action
    
    @MainActor
    private func executeSelectedAction() async {
        guard !isProcessingAction else {
            return
        }
        
        guard !pendingActionId.isEmpty else {
            actionResultMessage =
            "No valid action was selected. Please try again."
            activeAlert = .result
            return
        }
        
        isProcessingAction = true
        
        defer {
            isProcessingAction = false
        }
        
        let viewModel = container.makeAlertsViewModel()
        
        let response = await viewModel.processDynamicActions(
            applicationId: alert.applicationId,
            id: alert.id,
            alertId: alert.alertId,
            aggregateAlertIds: alert.aggregateAlertId,
            actionId: pendingActionId,
            caption: pendingCaption
        )
        
        guard let result = response.first else {
            actionResultMessage =
            "Unable to process the selected action. Please try again."
            activeAlert = .result
            return
        }
        
        if result.errorCode == 0 {
            actionResultMessage = result.message ?? "Successful"
            coordinator.refreshAlertsAfterAction = true
            shouldReturnToAlerts = true
            
        } else if result.errorCode == 412 {
            actionResultMessage = result.message ??
            "Your session has expired. Please log in again."
            shouldLogout = true
            
        } else {
            actionResultMessage = result.message ??
            "The action could not be completed."
        }
        
        activeAlert = .result
    }
    
    // MARK: - Handle Result
    
    private func handleResultDismissal() {
        let shouldDoLogout = shouldLogout
        let shouldGoBack = shouldReturnToAlerts
        
        shouldLogout = false
        shouldReturnToAlerts = false
        
        // Wait a tiny moment so the alert can close first, then navigate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if shouldDoLogout {
                coordinator.logout()
            } else if shouldGoBack {
                coordinator.backToAlerts()
            }
        }
    }
}
 
