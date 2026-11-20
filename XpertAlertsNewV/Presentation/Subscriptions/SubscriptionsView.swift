
import SwiftUI

struct SubscriptionsView: View {

    @StateObject private var viewModel: SubscriptionsViewModel

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

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header

            HStack(spacing: 12) {

                Image(systemName: "rectangle.stack.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.themeOrange)
                    .frame(width: 44, height: 44)
                    .background(Color.themeOrange.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                             RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                    Color.themeOrange.opacity(0.5),
                                    lineWidth: 1 ))

                Text("Subscriptions")
                    .font(.avenirBold(size: 21))
                    .foregroundStyle(Color.themeOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 4)

                // Create Subscription

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
                        .foregroundStyle(Color.themeOrange)
                        .frame(width: 54, height: 44)
                        .background(Color.themeOrange.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                                 RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                        Color.themeOrange.opacity(0.5),
                                        lineWidth: 1 ))
                                        
                                         
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Create Subscription")

                // Search Subscriptions

                NavigationLink {
                    SubscriptionsSearchView(
                        viewModel: viewModel,
                        applications: applications,
                        selectedApplicationId: $selectedApplicationId,
                        isLoadingApplications: isLoadingApplications,
                        applicationError: applicationError,
                        onSearch: {
                            performSearch()
                        },
                        onReset: {
                            selectedApplicationId = nil
                            viewModel.searchName = ""
                            viewModel.searchActive = 1
                            viewModel.resetSearch()
                        }
                    )
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.themeOrange)
                        .frame(width: 44, height: 44)
                        .background(Color.themeOrange.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                                 RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                        Color.themeOrange.opacity(0.5),
                                        lineWidth: 1 ))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Search Subscriptions")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

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
                        .font(.avenirRegular(size: 32))
                        .foregroundStyle(.secondary)

                    Text(errorMessage)
                        .font(.avenirRegular(size: 15))
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
                    .font(.avenirRegular(size: 32))
                    .foregroundStyle(.secondary)

                Text("No subscriptions found")
                    .font(.avenirDemiBold(size: 17))
                    .padding(.top, 4)

                Spacer()

            } else {

                ScrollView {

                    LazyVStack(spacing: 0) {

                        ForEach(viewModel.subscriptions) { subscription in
                            NavigationLink {
                                CreateSubscriptionView(
                                    getApplicationsUseCase: container.getApplicationsUseCase,
                                    getAlertDefinitionsUseCase: container.getAlertDefinitionsUseCase,
                                    userRepository: container.userRepository,
                                    saveSubscriptionUseCase: container.saveSubscriptionUseCase,
                                    getDuplicateSubscriptionUseCase: container.getDuplicateSubscriptionUseCase,
                                    subscriptionToEdit: subscription,
                                    getSubscriptionDetailsUseCase: container.getSubscriptionDetailsUseCase,
                                    onSaveSuccess: {
                                        viewModel.loadSubscriptions()
                                    }
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

    // MARK: - Search Action

    private func performSearch() {
        viewModel.search(applicationId: selectedApplicationId)
    }

    // MARK: - Load Applications

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
                        .font(.avenirMedium(size: 16))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)

                    Text(subscription.applicationName ?? "-")
                        .font(.avenirRegular(size: 12))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)

                    if !notificationTypes.isEmpty {
                        Text(notificationTypes)
                            .font(.avenirRegular(size: 12))
                            .foregroundStyle(Color.themeOrange)
                    }
                }

                Spacer(minLength: 4)

                Image(systemName: "chevron.right")
                    .font(.avenirMedium(size: 13))
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

