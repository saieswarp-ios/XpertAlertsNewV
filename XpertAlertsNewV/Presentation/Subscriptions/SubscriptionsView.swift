
import SwiftUI

struct SubscriptionsView: View {

    @StateObject private var viewModel: SubscriptionsViewModel
    @Environment(\.dismiss) private var dismiss

    let container: DIContainer

    @State private var applications: [Application] = []
    @State private var selectedApplicationId: Int? = nil
    @State private var isLoadingApplications = false
    @State private var applicationError: String?

    init(container: DIContainer) {
        self.container = container
        _viewModel = StateObject(
            wrappedValue: container.makeSubscriptionsViewModel()
        )
    }

    private var activeStatusBinding: Binding<Int> {
        Binding(
            get: { viewModel.searchActive },
            set: { viewModel.searchActive = $0 }
        )
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header

            HStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.themeOrange)
                        .frame(width: 28, height: 40)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")

                Image(systemName: "rectangle.stack.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.themeOrange)
                    .frame(width: 44, height: 44)
                    .background(Color.themeOrange.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text("Subscriptions")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(Color.themeOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 4)

                NavigationLink {
                    CreateSubscriptionView(
                        getApplicationsUseCase:
                            container.getApplicationsUseCase,
                        getAlertDefinitionsUseCase:
                            container.getAlertDefinitionsUseCase,
                        userRepository:
                            container.userRepository,
                        saveSubscriptionUseCase:
                            container.saveSubscriptionUseCase,
                        getDuplicateSubscriptionUseCase:
                            container.getDuplicateSubscriptionUseCase,
                        onSaveSuccess: {
                            viewModel.loadSubscriptions()
                        }
                    )
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 54, height: 44)
                        .background(Color.themeOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Create Subscription")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // MARK: - Search Filters

            VStack(alignment: .leading, spacing: 12) {

                // Application filter
                VStack(alignment: .leading, spacing: 5) {
                    Text("Application")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)

                    Picker("Application", selection: $selectedApplicationId) {
                        Text("All Applications")
                            .tag(Int?.none)

                        ForEach(applications) { application in
                            Text(application.name)
                                .tag(Optional(application.id))
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Color.themeOrange)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .frame(height: 44)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                // Alert name search
                VStack(alignment: .leading, spacing: 5) {
                    Text("Alert Name")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)

                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)

                        TextField(
                            "Enter alert name",
                            text: $viewModel.searchName
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.search)
                        .onSubmit {
                            performSearch()
                        }

                        if !viewModel.searchName.isEmpty {
                            Button {
                                viewModel.searchName = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Clear alert name")
                        }
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                // Active status filter
                VStack(alignment: .leading, spacing: 5) {
                    Text("Active Status")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)

                    Picker("Active Status", selection: activeStatusBinding) {
                        Text("Yes").tag(1)
                        Text("No").tag(0)
                        Text("All").tag(2)
                    }
                    .pickerStyle(.segmented)
                }

                // Search and Reset buttons
                HStack(spacing: 10) {
                    Button {
                        performSearch()
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                            .font(.system(size: 15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .foregroundStyle(.white)
                            .background(Color.themeOrange)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isLoading || isLoadingApplications)

                    Button {
                        selectedApplicationId = nil
                        viewModel.searchName = ""
                        viewModel.searchActive = 1
                        viewModel.resetSearch()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.system(size: 15, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .foregroundStyle(Color.themeOrange)
                            .background(Color.themeOrange.opacity(0.10))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isLoading)
                }

                if let applicationError {
                    Text(applicationError)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            Divider()

            // MARK: - Subscription Content

            if viewModel.isLoading {
                Spacer()

                ProgressView("Loading subscriptions...")

                Spacer()

            } else if let errorMessage = viewModel.errorMessage {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 32))
                        .foregroundStyle(.secondary)

                    Text(errorMessage)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)

                    Button("Retry") {
                        viewModel.loadSubscriptions()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.themeOrange)
                }
                .padding(.horizontal, 20)

                Spacer()

            } else if viewModel.subscriptions.isEmpty {
                Spacer()

                Image(systemName: "rectangle.stack")
                    .font(.system(size: 32))
                    .foregroundStyle(.secondary)

                Text("No subscriptions found")
                    .font(.headline)
                    .padding(.top, 4)

                Spacer()

            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.subscriptions) { subscription in
                            NavigationLink {
                                SubscriptionDetailView(
                                    subscription: subscription,
                                    viewModel: viewModel,
                                    container: container
                                )
                            } label: {
                                SubscriptionRow(
                                    subscription: subscription
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .refreshable {
                    viewModel.loadSubscriptions()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await loadApplications()
            viewModel.loadSubscriptions()
        }
    }

    // MARK: - Search Actions

    private func performSearch() {
        viewModel.search(applicationId: selectedApplicationId)
    }

    // MARK: - Load Real Applications

    @MainActor
    private func loadApplications() async {
        guard applications.isEmpty else { return }

        isLoadingApplications = true
        applicationError = nil

        do {
            applications = try await container.getApplicationsUseCase.execute()
        } catch {
            applicationError = "Unable to load applications."
            print("Load applications error: \(error)")
        }

        isLoadingApplications = false
    }
}

// MARK: - Subscription Row

struct SubscriptionRow: View {

    let subscription: Subscription

    private var notificationTypes: String {
        let deviceEnabled = subscription.device == "Yes"
        let emailEnabled = subscription.email == "Yes"

        switch (deviceEnabled, emailEnabled) {
        case (true, true):
            return "Device, Email"
        case (true, false):
            return "Device"
        case (false, true):
            return "Email"
        case (false, false):
            return ""
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(subscription.alertName ?? "-")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)

                    Text(subscription.applicationName ?? "-")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)

                    if !notificationTypes.isEmpty {
                        Text(notificationTypes)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.themeOrange)
                    }
                }

                Spacer(minLength: 4)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())

            Divider()
        }
    }
}

