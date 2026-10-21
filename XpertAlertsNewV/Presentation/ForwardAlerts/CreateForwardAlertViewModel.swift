//
//  CreateForwardAlertViewModel.swift
//  XpertAlertsNewV
//
import SwiftUI
import Combine

@MainActor
final class CreateForwardAlertViewModel: ObservableObject {

    // MARK: - Dependencies

    private let getApplicationsUseCase: GetForwardApplicationsUseCase
    private let getUsersUseCase: GetForwardUsersUseCase
    private let repository: ForwardAlertsRepository
    private let saveMappedUserUseCase: SaveMappedUserUseCase
    
    private let duplicateForwardAlertUseCase:
        DuplicateForwardAlertUseCase
    private let userRepository: UserRepository

    // MARK: - Applications

    @Published var applications: [ForwardApplication] = []
    @Published var selectedApplication: ForwardApplication?

    // MARK: - Users

    @Published var users: [ForwardUser] = []
    @Published var selectedUser: ForwardUser?

    // MARK: - Email

    @Published var selectedEmail: String = ""

    // MARK: - Loading

    @Published var isLoading = false
    @Published var isLoadingUsers = false
    @Published var isLoadingEmail = false
    @Published var isSaving = false

    // MARK: - Error / Message

    @Published var errorMessage: String?
    @Published var saveMessage: String?

    // MARK: - Init

    init(
        getApplicationsUseCase: GetForwardApplicationsUseCase,
        getUsersUseCase: GetForwardUsersUseCase,
        repository: ForwardAlertsRepository,
        saveMappedUserUseCase: SaveMappedUserUseCase,
        duplicateForwardAlertUseCase: DuplicateForwardAlertUseCase,
        userRepository: UserRepository
    ) {
        self.getApplicationsUseCase = getApplicationsUseCase
        self.getUsersUseCase = getUsersUseCase
        self.repository = repository
        self.saveMappedUserUseCase = saveMappedUserUseCase
        self.duplicateForwardAlertUseCase =
            duplicateForwardAlertUseCase
        self.userRepository =
            userRepository
    }

    // MARK: - Load Applications

    func loadApplications() async {

        isLoading = true
        errorMessage = nil

        do {

            applications =
                try await getApplicationsUseCase.execute()

            print(
                "========== CREATE FORWARD APPLICATIONS =========="
            )

            print(
                "Number of Applications:",
                applications.count
            )

            for application in applications {

                print(
                    "ID:",
                    application.id,
                    "Name:",
                    application.name
                )
            }

            print(
                "================================================="
            )

        } catch {

            errorMessage =
                error.localizedDescription

            print(
                "CREATE FORWARD APPLICATION API FAILED:"
            )

            print(error)
        }

        isLoading = false
    }

    // MARK: - Select Application

    func selectApplication(
        _ application: ForwardApplication
    ) async {

        selectedApplication =
            application

        // Clear previous selection

        selectedUser = nil
        selectedEmail = ""
        users = []

        // Load users for selected application

        await loadUsers(
            applicationId: application.id
        )
    }

    // MARK: - Load Users

    private func loadUsers(
        applicationId: Int
    ) async {

        isLoadingUsers = true
        errorMessage = nil

        do {

            users =
                try await getUsersUseCase.execute(
                    applicationId: applicationId
                )

            print(
                "========== CREATE FORWARD USERS =========="
            )

            print(
                "Number of Users:",
                users.count
            )

            for user in users {

                print(
                    "ID:",
                    user.id,
                    "Name:",
                    user.userName
                )
            }

            print(
                "=========================================="
            )

        } catch {

            errorMessage =
                error.localizedDescription

            print(
                "GET FORWARD USERS ERROR:"
            )

            print(error)
        }

        isLoadingUsers = false
    }

    // MARK: - Select User

    func selectUser(
        _ user: ForwardUser
    ) {
        saveMessage = nil
        errorMessage = nil
        selectedUser =
            user

        selectedEmail = ""
        errorMessage = nil
        loadUserEmail(
            userId: user.id
        )
    }

    // MARK: - Load User Email

   
    // MARK: - Load User Email

    private func loadUserEmail(userId: Int) {
        isLoadingEmail = true
        errorMessage = nil
        selectedEmail = ""

        Task {
            do {
                selectedEmail = try await repository.getUserEmail(
                    userId: userId
                )

                print("SELECTED USER EMAIL:", selectedEmail)

            } catch {
                selectedEmail = ""
                errorMessage = "This user doesn't have a valid email address. Please select another user."

                print(
                    "GET USER EMAIL: No valid email available for user ID \(userId)"
                )
            }

            isLoadingEmail = false
        }
    }

    
    
    
    
    
    
    
    
    // MARK: - Save Mapped User

    func saveMappedUser(
        sortOrder: Int,
        active: Int
    ) async {

        guard let selectedApplication else {

            errorMessage =
                "Please select application"

            return
        }

        guard let selectedUser else {

            errorMessage =
                "Please select user"

            return
        }

        guard !selectedEmail.isEmpty else {

            errorMessage =
                "User email is not available"

            return
        }

        isSaving = true
        errorMessage = nil
        saveMessage = nil

        do {

            // MARK: - Check Duplicate

            guard let user = userRepository.getUser() else {

                errorMessage =
                    "User session not found"

                isSaving = false
                return
            }

            let duplicateResponse =
                try await duplicateForwardAlertUseCase.execute(
                    forwardAlertId: 0,
                    mappedUserId: selectedUser.id,
                    applicationId: selectedApplication.id,
                    sessionId: user.sessionId
                )

            print(
                "========== DUPLICATE FORWARD ALERT =========="
            )

            print(
                "Duplicate Count:",
                duplicateResponse.duplicateCount ?? -1
            )

            print(
                "Error Code:",
                duplicateResponse.errorCode ?? -1
            )

            print(
                "=============================================="
            )

            // MARK: - Stop if Duplicate

            guard duplicateResponse.duplicateCount == 0 else {

                errorMessage =
                    "User is already mapped to this application"

                isSaving = false
                return
            }

            // MARK: - Save Mapped User

            let response =
                try await saveMappedUserUseCase.execute(
                    mappedUserId: selectedUser.id,
                    applicationId: selectedApplication.id,
                    email: selectedEmail,
                    sortOrder: sortOrder,
                    active: active
                )

            print(
                "========== SAVE MAPPED USER =========="
            )

            print(
                "Error Code:",
                response.errorCode ?? -1
            )

            print(
                "Message:",
                response.message ?? "-"
            )

            print(
                "======================================"
            )

            if response.errorCode == 1 {

                saveMessage =
                    response.message ??
                    "User mapped successfully"

            } else {

                errorMessage =
                    response.message ??
                    "User is already mapped"
            }

        } catch {

            errorMessage =
                error.localizedDescription

            print(
                "SAVE MAPPED USER ERROR:"
            )

            print(error)
        }

        isSaving = false
    }
}
