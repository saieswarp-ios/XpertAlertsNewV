
import SwiftUI
import Combine

struct ForwardAlertsView: View {

    @StateObject private var viewModel: ForwardAlertsViewModel

    let createForwardAlertViewModel: CreateForwardAlertViewModel

    // MARK: - Multi-selection

    @State private var selectedAlertIDs: Set<Int> = []
    @State private var isSelectionMode = false

    // MARK: - Delete Confirmation

    @State private var alertToDelete: ForwardAlert?
    @State private var showDeleteConfirmation = false
    @State private var isBulkDelete = false

    @State private var deleteResultMessage: String?
    @State private var deleteResultIsError = false

    init(
        viewModel: ForwardAlertsViewModel,
        createForwardAlertViewModel: CreateForwardAlertViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.createForwardAlertViewModel = createForwardAlertViewModel
    }

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                // MARK: - Top Actions

               
                // MARK: - Top Actions

               HStack(spacing: 12) {

                   Image(systemName: "arrowshape.turn.up.right.fill")
                       .font(.system(size: 18, weight: .semibold))
                       .foregroundStyle(Color.themeOrange)
                       .frame(width: 40, height: 40)
                       .background(Color.themeOrange.opacity(0.12))
                       .clipShape(RoundedRectangle(cornerRadius: 12))

                   Text("Forward Alerts")
                       .font(.avenirBold(size: 21))
                       .foregroundStyle(Color.themeOrange)

                   Spacer()

                   NavigationLink {
                       CreateForwardAlertView(
                           viewModel: createForwardAlertViewModel
                       )
                   } label: {
                       HStack(spacing: 6) {
                           Image(systemName: "plus")
                           Text("Create")
                       }
                       .font(.avenirDemiBold(size: 15))
                       .foregroundStyle(Color.themeOrange)
                       .frame(height: 40)
                       .padding(.horizontal, 12)
                       .background(Color.themeOrange.opacity(0.12))
                       .clipShape(RoundedRectangle(cornerRadius: 12))
                   }
                   .buttonStyle(.plain)
               }

                // MARK: - Existing Forward Alerts

                VStack(alignment: .leading, spacing: 12) {

                    // MARK: - Select / Cancel

                    HStack {
                        Button(isSelectionMode ? "Cancel" : "Select") {
                            isSelectionMode.toggle()
                            selectedAlertIDs.removeAll()
                        }
                        .foregroundStyle(Color.themeOrange)

                        Spacer()
                    }

                    // MARK: - Selection Controls

                    if isSelectionMode {

                        HStack(spacing: 16) {

                            Button("Select All") {
                                selectedAlertIDs = Set(
                                    viewModel.forwardAlerts.map { $0.id }
                                )
                            }

                            Button("Clear Selection") {
                                selectedAlertIDs.removeAll()
                            }

                            Spacer()

                            Text("\(selectedAlertIDs.count) selected")
                                .font(.avenirRegular(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        .font(.avenirRegular(size: 15))
                        .foregroundStyle(Color.themeOrange)

                        Button("Delete Selected") {
                            isBulkDelete = true
                            showDeleteConfirmation = true
                        }
                        .disabled(selectedAlertIDs.isEmpty)
                    }

                    // MARK: - Forward Alerts List

                    if viewModel.forwardAlerts.isEmpty {

                        Text("No forward alerts found")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 8)

                    } else {

                        ForEach(viewModel.forwardAlerts) { alert in

                            VStack(alignment: .leading, spacing: 8) {

                                // Alert Header

                                HStack(spacing: 10) {

                                    if isSelectionMode {

                                        Button {

                                            if selectedAlertIDs.contains(alert.id) {
                                                selectedAlertIDs.remove(alert.id)
                                            } else {
                                                selectedAlertIDs.insert(alert.id)
                                            }

                                        } label: {

                                            Image(
                                                systemName: selectedAlertIDs.contains(alert.id)
                                                    ? "checkmark.circle.fill"
                                                    : "circle"
                                            )
                                            .foregroundStyle(Color.themeOrange)
                                            .font(.avenirDemiBold(size: 20))
                                        }
                                        .buttonStyle(.plain)
                                    }

                                    Text(alert.userName)
                                        .font(.avenirMedium(size: 17))

                                    Spacer()

                                    Button {

                                        let newStatus = alert.active == 1 ? 0 : 1

                                        Task {
                                            await viewModel.updateForwardAlertsUserStatus(
                                                alert,
                                                status: newStatus
                                            )
                                        }

                                    } label: {
                                        statusLabel(for: alert)
                                    }
                                    .buttonStyle(.plain)
                                }

                                Text(alert.applicationName)
                                    .font(.avenirRegular(size: 15))
                                    .foregroundStyle(.secondary)

                                Text(alert.email)
                                    .font(.avenirRegular(size: 12))
                                    .foregroundStyle(.secondary)

                                // Delete

                                Button {

                                    alertToDelete = alert
                                    isBulkDelete = false
                                    showDeleteConfirmation = true

                                } label: {

                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                    }
                                    .font(.avenirRegular(size: 12))
                                    .foregroundStyle(.red)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(16)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        }
                    }
                }

                // MARK: - Delete Result

                if let deleteResultMessage = deleteResultMessage {

                    HStack(alignment: .top, spacing: 8) {

                        Image(
                            systemName: deleteResultIsError
                                ? "exclamationmark.circle.fill"
                                : "checkmark.circle.fill"
                        )

                        Text(deleteResultMessage)
                            .font(.avenirRegular(size: 12))
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                    }
                    .foregroundStyle(
                        deleteResultIsError ? .red : .green
                    )
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                deleteResultIsError
                                    ? Color.red.opacity(0.08)
                                    : Color.green.opacity(0.08)
                            )
                    )
                }

                // MARK: - Existing Error

                if let errorMessage = viewModel.errorMessage {

                    Text(errorMessage)
                        .font(.avenirRegular(size: 12))
                        .foregroundStyle(.red)
                }

                Spacer(minLength: 20)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 30)
        }
        .refreshable {
            await viewModel.loadForwardAlerts()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadForwardAlerts()
        }
        .alert(
            isBulkDelete
                ? "Delete Selected Alerts?"
                : "Delete Forward Alert?",
            isPresented: $showDeleteConfirmation
        ) {

            Button("Cancel", role: .cancel) {
                alertToDelete = nil
                isBulkDelete = false
            }

            Button("Delete", role: .destructive) {
                Task {
                    await performDelete()
                }
            }

        } message: {

            Text(
                isBulkDelete
                    ? "Are you sure you want to delete the selected alerts?"
                    : "Are you sure you want to delete this forward alert?"
            )
        }
    }

    // MARK: - Status Label

    private func statusLabel(for alert: ForwardAlert) -> some View {

        let isActive = alert.active == 1

        return Text(isActive ? "Active" : "Inactive")
            .font(.avenirMedium(size: 12))
            .foregroundColor(
                isActive ? Color.green : Color.secondary
            )
    }

    // MARK: - Perform Delete

    @MainActor
    private func performDelete() async {

        deleteResultMessage = nil
        deleteResultIsError = false

        if isBulkDelete {

            let alertsToDelete = viewModel.forwardAlerts.filter {
                selectedAlertIDs.contains($0.id)
            }

            guard !alertsToDelete.isEmpty else {

                deleteResultMessage = "No alerts selected for deletion."
                deleteResultIsError = true
                isBulkDelete = false

                return
            }

            var successCount = 0
            var failureCount = 0
            var lastFailureMessage: String?

            for alert in alertsToDelete {

                await viewModel.deleteForwardAlert(alert)

                if let error = viewModel.errorMessage {
                    failureCount += 1
                    lastFailureMessage = error
                } else {
                    successCount += 1
                }
            }

            selectedAlertIDs.removeAll()
            isSelectionMode = false
            isBulkDelete = false

            await viewModel.loadForwardAlerts()

            if failureCount == 0 {

                let noun = successCount == 1
                    ? "forward alert"
                    : "forward alerts"

                deleteResultMessage =
                    "\(successCount) \(noun) deleted successfully."

                deleteResultIsError = false

            } else if successCount > 0 {

                deleteResultMessage =
                    "\(successCount) deleted, \(failureCount) failed. " +
                    (lastFailureMessage ?? "")

                deleteResultIsError = true

            } else {

                deleteResultMessage =
                    "Unable to delete the selected forward alerts. " +
                    (lastFailureMessage ?? "Please try again.")

                deleteResultIsError = true
            }

        } else if let alert = alertToDelete {

            await viewModel.deleteForwardAlert(alert)

            if let error = viewModel.errorMessage {

                deleteResultMessage = "Deletion failed: \(error)"
                deleteResultIsError = true

            } else {

                deleteResultMessage = "Forward alert deleted successfully."
                deleteResultIsError = false
            }

            alertToDelete = nil
        }
    }
}

