
import SwiftUI

struct CreateSubscriptionView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var applications: [Application] = []
    @State private var alertDefinitions: [AlertDefinition] = []

    @State private var selectedApplication: Application?
    @State private var selectedAlertDefinition: AlertDefinition?

    @State private var alertFlag = 1
    @State private var isActive = true

    @State private var alertName = ""
    @State private var email = ""
    @State private var subject = ""
    @State private var threshold = ""
    @State private var sortOrder = ""

    @State private var isSaving = false
    @State private var isLoadingDetails = false
    @State private var saveMessage: String?

    let getApplicationsUseCase: GetApplicationsUseCase
    let getAlertDefinitionsUseCase: GetAlertDefinitionsUseCase
    let userRepository: UserRepository
    let saveSubscriptionUseCase: SaveSubscriptionUseCase
    let getDuplicateSubscriptionUseCase: GetDuplicateSubscriptionUseCase

    // Nil when creating a new subscription.
    var subscriptionToEdit: Subscription? = nil
    var getSubscriptionDetailsUseCase: GetSubscriptionDetailsUseCase? = nil

    let onSaveSuccess: () -> Void

    private var isEditMode: Bool {
        subscriptionToEdit != nil
    }

    var body: some View {
        Form {

            // MARK: - Application

            Section {
                Picker(
                    "Application",
                    selection: $selectedApplication
                ) {
                    Text("Select Application")
                        .tag(nil as Application?)

                    ForEach(applications) { application in
                        Text(application.name)
                            .tag(application as Application?)
                    }
                }
                .onChange(of: selectedApplication) { _, newApplication in
                    selectedAlertDefinition = nil
                    alertDefinitions = []
                    alertName = ""

                    guard let application = newApplication else {
                        return
                    }

                    Task {
                        await loadAlertDefinitions(
                            applicationId: application.id
                        )
                    }
                }
            }

            // MARK: - Alert Type

            Section("Alert Type") {
                Picker("Type", selection: $alertFlag) {
                    Text("Alert Definition").tag(1)
                    Text("Aggregate Job").tag(2)
                }
                .pickerStyle(.segmented)
                .onChange(of: alertFlag) { _, newValue in
                    selectedAlertDefinition = nil
                    alertDefinitions = []
                    alertName = ""

                    guard let application = selectedApplication else {
                        return
                    }

                    Task {
                        await loadAlertDefinitions(
                            applicationId: application.id,
                            flag: newValue
                        )
                    }
                }
            }

            // MARK: - Alert Definition / Aggregate Job

            Section {
                Picker(
                    alertFlag == 2 ? "Aggregate Job" : "Alert Definition",
                    selection: $selectedAlertDefinition
                ) {
                    Text(
                        alertFlag == 2
                            ? "Select Aggregate Job"
                            : "Select Alert Definition"
                    )
                    .tag(nil as AlertDefinition?)

                    ForEach(alertDefinitions) { definition in
                        Text(definition.name)
                            .tag(definition as AlertDefinition?)
                    }
                }
                .onChange(of: selectedAlertDefinition) { _, newDefinition in
                    updateAlertName(for: newDefinition)
                }
            }

            // MARK: - Alert Name

            Section {
                TextField("Alert Name", text: $alertName)
                    .disabled(true)
            }

            // MARK: - Email

            Section {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            // MARK: - Message Subject

            Section {
                TextField("Message Subject", text: $subject)
            }

            // MARK: - Sort Order

            Section {
                TextField("Sort Order", text: $sortOrder)
                    .keyboardType(.numberPad)
            }

            // MARK: - Threshold

            if alertFlag == 2 {
                Section {
                    TextField("Threshold", text: $threshold)
                        .keyboardType(.numberPad)
                }
            }

            // MARK: - Activate

            Section {
                HStack {
                    Text("Activate")

                    Spacer()

                    Text(isActive ? "Yes" : "No")
                        .foregroundStyle(
                            isActive ? Color.green : Color.secondary
                        )

                    Toggle("Activate", isOn: $isActive)
                        .labelsHidden()
                        .tint(.green)
                }
            }

            // MARK: - Save

            Section {
                Button {
                    saveSubscription()
                } label: {
                    HStack {
                        Spacer()

                        if isSaving {
                            ProgressView()
                                .tint(.white)

                            Text(
                                isEditMode
                                    ? "Updating..."
                                    : "Creating..."
                            )
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        } else {
                            Text(
                                isEditMode
                                    ? "Update Subscription"
                                    : "Save"
                            )
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        }

                        Spacer()
                    }
                    .frame(height: 44)
                    .background(Color.themeOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(isSaving || isLoadingDetails)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(
            isEditMode ? "Edit Subscription" : "Create Subscription"
        )
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if isLoadingDetails {
                ProgressView("Loading subscription...")
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .alert(
            "Subscription",
            isPresented: Binding(
                get: { saveMessage != nil },
                set: { if !$0 { saveMessage = nil } }
            )
        ) {
            Button("OK") {
                saveMessage = nil
            }
        } message: {
            Text(saveMessage ?? "")
        }
        .task {
            await loadApplications()

            if let subscription = subscriptionToEdit {
                await loadExistingSubscription(subscription)
            }
        }
    }

    // MARK: - Load Applications

    @MainActor
    private func loadApplications() async {
        do {
            applications = try await getApplicationsUseCase.execute()
        } catch {
            saveMessage = "Unable to load applications. Please try again."
            print("GET APPLICATIONS ERROR:", error)
        }
    }

    // MARK: - Load Alert Definitions

    @MainActor
    private func loadAlertDefinitions(
        applicationId: Int,
        flag: Int? = nil
    ) async {
        guard let user = userRepository.getUser() else {
            saveMessage = "User session not found. Please login again."
            return
        }

        do {
            let definitions = try await getAlertDefinitionsUseCase.execute(
                applicationId: applicationId,
                alertFlag: flag ?? alertFlag,
                sessionId: user.sessionId
            )

            alertDefinitions = definitions
        } catch {
            saveMessage = "Unable to load alert definitions."
            print("GET ALERT DEFINITIONS ERROR:", error)
        }
    }

    // MARK: - Load Existing Subscription

    @MainActor
    private func loadExistingSubscription(
        _ subscription: Subscription
    ) async {
        guard let detailsUseCase = getSubscriptionDetailsUseCase else {
            saveMessage = "Subscription details service is unavailable."
            return
        }

        guard let user = userRepository.getUser() else {
            saveMessage = "User session not found. Please login again."
            return
        }

        isLoadingDetails = true
        defer { isLoadingDetails = false }

        do {
            let details = try await detailsUseCase.execute(
                subscriptionId: subscription.id,
                sessionId: user.sessionId
            )

            guard details.errorCode == nil || details.errorCode == 0 else {
                saveMessage = "Unable to load subscription details."
                return
            }

            alertFlag = details.alertFlag ?? subscription.alertFlag ?? 1
            isActive = details.active == 1

            alertName = details.alertName ?? subscription.alertName ?? ""
            email = details.emailId ?? subscription.email ?? ""
            subject = details.subject ?? ""
            threshold = details.threshold.map(String.init) ?? ""
            sortOrder = details.sortOrder.map(String.init) ?? ""

            if let applicationId = details.applicationId {
                selectedApplication = applications.first {
                    $0.id == applicationId
                }

                guard selectedApplication != nil else {
                    saveMessage = "The subscription application was not found."
                    return
                }

                await loadAlertDefinitions(
                    applicationId: applicationId,
                    flag: alertFlag
                )
            }

            if let alertDefinitionId = details.alertDefId {
                selectedAlertDefinition = alertDefinitions.first {
                    $0.id == alertDefinitionId
                }
            }

            if selectedAlertDefinition == nil {
                saveMessage = "The saved alert definition could not be selected."
            }
        } catch {
            saveMessage = "Unable to load subscription details."
            print("LOAD SUBSCRIPTION DETAILS ERROR:", error)
        }
    }

    // MARK: - Update Alert Name

    private func updateAlertName(for definition: AlertDefinition?) {
        guard let definition else {
            alertName = ""
            return
        }

        if alertFlag == 2 {
            alertName = definition.name
        } else {
            alertName = "\(selectedApplication?.name ?? "") - \(definition.name)"
        }
    }

    // MARK: - Save Subscription

    @MainActor
    private func saveSubscription() {
        guard let application = selectedApplication else {
            saveMessage = "Please select an application."
            return
        }

        guard let definition = selectedAlertDefinition else {
            saveMessage = "Please select an alert definition."
            return
        }

        guard let user = userRepository.getUser() else {
            saveMessage = "User session not found. Please login again."
            return
        }

        let existingSubscriptionId = subscriptionToEdit?.id ?? 0
        let thresholdValue = Int(threshold) ?? 0
        let sortOrderValue = Int(sortOrder) ?? 0

        isSaving = true
        saveMessage = nil

        Task { @MainActor in
            defer { isSaving = false }

            do {
                // Check for duplicates before saving.

                let duplicateResponse =
                    try await getDuplicateSubscriptionUseCase.execute(
                        userId: user.userId,
                        applicationId: application.id,
                        alertDefinitionId: definition.id,
                        alertFlag: alertFlag,
                        userSubId: existingSubscriptionId,
                        sessionId: user.sessionId
                    )

                if (duplicateResponse.duplicateCount ?? 0) > 0 {
                    saveMessage = duplicateResponse.errorMessage
                        ?? "Record already exists."
                    return
                }

                let response = try await saveSubscriptionUseCase.execute(
                    userSubId: existingSubscriptionId,
                    alertName: alertName,
                    applicationId: String(application.id),
                    alertDefId: definition.id,
                    userId: user.userId,
                    alertTypes: 1,
                    mailId: email,
                    messageBody: "",
                    subject: subject,
                    alertFlag: alertFlag,
                    threshold: thresholdValue,
                    sortOrder: sortOrderValue,
                    active: isActive ? 1 : 0,
                    sessionId: user.sessionId
                )

                if response.errorCode == 0 {
                    onSaveSuccess()
                    dismiss()
                } else {
                    saveMessage = response.message
                        ?? (
                            isEditMode
                                ? "Unable to update subscription."
                                : "Unable to create subscription."
                        )
                }
            } catch {
                saveMessage = isEditMode
                    ? "Unable to update subscription."
                    : "Unable to create subscription."

                print("SAVE SUBSCRIPTION ERROR:", error)
            }
        }
    }
}

