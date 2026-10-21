
import SwiftUI
import Combine

@MainActor
final class SubscriptionsViewModel: ObservableObject {

    @Published var subscriptions: [Subscription] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var searchName = ""
    @Published var searchActive = 1
    @Published var selectedApplicationId: Int? = nil

    @Published var selectedSubscriptionDetails: SubscriptionDetails?
    @Published var isLoadingDetails = false

    private let getSubscriptionsUseCase: GetSubscriptionsUseCase
    private let userRepository: UserRepository
    private let getSubscriptionDetailsUseCase: GetSubscriptionDetailsUseCase

    init(
        getSubscriptionsUseCase: GetSubscriptionsUseCase,
        getSubscriptionDetailsUseCase: GetSubscriptionDetailsUseCase,
        userRepository: UserRepository
    ) {
        self.getSubscriptionsUseCase = getSubscriptionsUseCase
        self.getSubscriptionDetailsUseCase = getSubscriptionDetailsUseCase
        self.userRepository = userRepository
    }

    func loadSubscriptions() {
        errorMessage = nil

        guard let user = userRepository.getUser() else {
            errorMessage = "Unable to retrieve user information."
            return
        }

        let assignedApplicationIds = user.applicationIds
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !assignedApplicationIds.isEmpty else {
            subscriptions = []
            errorMessage = "No application is assigned to this user."
            return
        }

        // Use the selected application only if it is assigned to the user.
        let applicationIds: String

        if let selectedId = selectedApplicationId {
            let selectedIdString = String(selectedId)

            guard assignedApplicationIds.contains(selectedIdString) else {
                subscriptions = []
                errorMessage = "The selected application is not assigned to this user."
                return
            }

            applicationIds = selectedIdString
        } else {
            applicationIds = assignedApplicationIds.joined(separator: ",")
        }

        isLoading = true

        Task {
            do {
                let result = try await getSubscriptionsUseCase.execute(
                    userId: user.userId,
                    applicationId: applicationIds,
                    searchName: searchName,
                    searchActive: searchActive,
                    sessionId: user.sessionId
                )

                subscriptions = result
                errorMessage = nil
            } catch {
                errorMessage = "Unable to load subscriptions."
                print("Load subscriptions error: \(error)")
            }

            isLoading = false
        }
    }

    func search(applicationId: Int?) {
        selectedApplicationId = applicationId
        loadSubscriptions()
    }

    func resetSearch() {
        searchName = ""
        searchActive = 1
        selectedApplicationId = nil
        loadSubscriptions()
    }

    func loadSubscriptionDetails(subscriptionId: Int) {
        guard let user = userRepository.getUser() else {
            errorMessage = "Unable to retrieve user information."
            return
        }

        isLoadingDetails = true

        Task {
            do {
                let details = try await getSubscriptionDetailsUseCase.execute(
                    subscriptionId: subscriptionId,
                    sessionId: user.sessionId
                )

                selectedSubscriptionDetails = details
            } catch {
                errorMessage = "Unable to load subscription details."
                print("Load subscription details error: \(error)")
            }

            isLoadingDetails = false
        }
    }
}

