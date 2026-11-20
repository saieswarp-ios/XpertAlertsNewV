//
//  AlertActionsMenu.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 19/11/26.
//


import SwiftUI

struct AlertActionsMenu: View {

    let alert: Alert
    let coordinator: AppCoordinator

    @ObservedObject var viewModel: AlertsViewModel

// Alert Presentation

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

// State

    @State private var alertButtonDetails: [GetAlertButtonDetailsResponse] = []
    @State private var actionOptions: [String] = []

    @State private var isLoadingActions = true
    @State private var isProcessingAction = false

    @State private var activeAlert: ActiveAlert?

    @State private var pendingActionId = ""
    @State private var pendingCaption = ""
    @State private var pendingPrompt = ""

    @State private var actionResultMessage = ""
    @State private var shouldLogout = false

    // Body

    var body: some View {

        Menu {

            if isLoadingActions {

                Button("Loading actions...") {}
                    .disabled(true)

            } else if actionOptions.isEmpty {

                Button("No actions available") {}
                    .disabled(true)

            } else {

                ForEach(actionOptions, id: \.self) { option in

                    Button(option) {
                        selectAction(option)
                    }
                    .disabled(isProcessingAction)
                }
            }

        } label: {

            Image(systemName: "ellipsis")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.themeOrange)
                .frame(width: 36, height: 36)
                .contentShape(Rectangle())
        }
        .menuStyle(.borderlessButton)
        .accessibilityLabel("Alert actions")
        .disabled(isProcessingAction)

        .task {
            await loadAlertActions()
        }

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

  // Load Actions

    @MainActor
    private func loadAlertActions() async {

        isLoadingActions = true

        let result = await viewModel.loadAlertButtonDetails(
            applicationId: alert.applicationId,
            alertDefinitionId: alert.alertDefId
        )

        alertButtonDetails = result

        let captions = result.first?.captions ?? ""

        actionOptions = splitValues(captions)

        isLoadingActions = false
    }

// Parse API Values

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

// Select Action

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
            return
        }

        pendingCaption = caption
        pendingActionId = actionIDs[index]
        pendingPrompt = index < prompts.count ? prompts[index] : ""

        if pendingPrompt.isEmpty {

            Task {
                await executeSelectedAction()
            }

        } else {

            activeAlert = .confirmation
        }
    }

 // Clear Pending Action

    private func clearPendingAction() {

        pendingActionId = ""
        pendingCaption = ""
        pendingPrompt = ""
    }

// Execute Action

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

            // AlertsView already observes this flag and refreshes the list.
            coordinator.refreshAlertsAfterAction = true

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

  // Handle Result

    private func handleResultDismissal() {

        let logout = shouldLogout
        shouldLogout = false

        if logout {

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                coordinator.logout()
            }
        }
    }
}
