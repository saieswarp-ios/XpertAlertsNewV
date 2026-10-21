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

                // MARK: - Header

                AppScreenHeader(
                    title: "Forward Alerts",
                    subtitle: nil,
                    icon: "arrowshape.turn.up.right.fill"
                )
                .padding(.bottom, 4)

                // MARK: - Existing Forward Alerts

                VStack(alignment: .leading, spacing: 12) {

                    HStack {

                        Text("Forward Alerts")
                            .font(.headline)

                        Spacer()

                        Button(isSelectionMode ? "Cancel" : "Select") {
                            isSelectionMode.toggle()
                            selectedAlertIDs.removeAll()
                        }
                        .foregroundStyle(Color.themeOrange)
                    }

                    // MARK: - Backend Status Actions

                    HStack(spacing: 12) {

                        Button {
                            Task {
                                await viewModel.updateForwardAlertsStatus(
                                    status: 1
                                )
                            }
                        } label: {
                            Text("Select All")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.themeOrange)
                                )
                        }
                        .buttonStyle(.plain)

                        Button {
                            Task {
                                await viewModel.updateForwardAlertsStatus(
                                    status: 0
                                )
                            }
                        } label: {
                            Text("Unselect All")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.primary)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            Color(.secondarySystemBackground)
                                        )
                                )
                        }
                        .buttonStyle(.plain)
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
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .font(.subheadline)
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
                                                systemName:
                                                    selectedAlertIDs.contains(alert.id)
                                                    ? "checkmark.circle.fill"
                                                    : "circle"
                                            )
                                            .foregroundStyle(Color.themeOrange)
                                            .font(.title3)
                                        }
                                        .buttonStyle(.plain)
                                    }

                                    Text(alert.userName)
                                        .font(.body)
                                        .fontWeight(.medium)

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
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                Text(alert.email)
                                    .font(.caption)
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
                                    .font(.caption)
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
                                    .fill(
                                        Color(.secondarySystemBackground)
                                    )
                            )
                        }
                    }
                }

                // MARK: - Create Forward Alert

                Text("Create Forward Alert")
                    .font(.title3)
                    .fontWeight(.semibold)

                NavigationLink {
                    CreateForwardAlertView(
                        viewModel: createForwardAlertViewModel
                    )
                } label: {
                    HStack {
                        Image(systemName: "plus")

                        Text("Create Forward Alert")
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.themeOrange)
                    )
                }
                .buttonStyle(.plain)

                // MARK: - Applications

                VStack(alignment: .leading, spacing: 8) {

                    Text("Application")
                        .font(.headline)

                    if viewModel.isLoadingApplications {

                        ProgressView("Loading Applications...")

                    } else {

                        ForEach(viewModel.applications) { application in

                            Button {
                                Task {
                                    await viewModel.selectApplication(application)
                                }
                            } label: {
                                HStack {

                                    Text(application.name)

                                    Spacer()

                                    if viewModel.selectedApplication?.id == application.id {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(Color.themeOrange)
                                    } else {
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            Color(.secondarySystemBackground)
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // MARK: - Users

                if viewModel.selectedApplication != nil {

                    VStack(alignment: .leading, spacing: 8) {

                        Text("User")
                            .font(.headline)

                        if viewModel.isLoadingUsers {

                            ProgressView("Loading Users...")

                        } else if viewModel.users.isEmpty {

                            Text("No users found")
                                .foregroundStyle(.secondary)

                        } else {

                            ForEach(viewModel.users) { user in

                                Button {
                                    viewModel.selectUser(user)
                                } label: {
                                    HStack {

                                        Text(user.userName)

                                        Spacer()

                                        if viewModel.selectedUser?.id == user.id {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(Color.themeOrange)
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                Color(.secondarySystemBackground)
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        // MARK: - Selected User Email

                        if viewModel.selectedUser != nil {

                            VStack(alignment: .leading, spacing: 8) {

                                Text("Email")
                                    .font(.headline)

                                HStack(spacing: 10) {

                                    Image(systemName: "envelope.fill")
                                        .foregroundStyle(Color.themeOrange)

                                    if viewModel.isLoadingEmail {

                                        ProgressView()

                                    } else if !viewModel.selectedEmail.isEmpty {

                                        Text(viewModel.selectedEmail)
                                            .foregroundStyle(.primary)
                                            .textSelection(.enabled)
                                    }

                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            Color(.secondarySystemBackground)
                                        )
                                )
                            }
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
                            .font(.caption)
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
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                Spacer(minLength: 20)
            }
            // Consistent outer padding
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
            await viewModel.loadApplications()
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
            .font(.caption)
            .fontWeight(.medium)
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
