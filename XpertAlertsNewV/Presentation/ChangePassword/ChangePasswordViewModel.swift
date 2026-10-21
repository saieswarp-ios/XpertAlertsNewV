import SwiftUI
import Combine

@MainActor
final class ChangePasswordViewModel: ObservableObject {

    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""

    @Published var isLoading = false
    @Published var message: String?
    @Published var isSuccess = false

    private let changePasswordUseCase: ChangePasswordUseCase
    private let userRepository: UserRepository

    init(
        changePasswordUseCase: ChangePasswordUseCase,
        userRepository: UserRepository
    ) {
        self.changePasswordUseCase = changePasswordUseCase
        self.userRepository = userRepository
    }

    func updatePassword() {

        message = nil
        isSuccess = false

        // Validate current password
        if currentPassword.isEmpty {
            message = "Please enter your current password."
            return
        }

        // Validate new password
        if newPassword.isEmpty {
            message = "Please enter a new password."
            return
        }

        // Validate confirm password
        if confirmPassword.isEmpty {
            message = "Please confirm your new password."
            return
        }

        // Check passwords match
        if newPassword != confirmPassword {
            message = "New password and confirm password do not match."
            return
        }

        // Get logged-in user
        guard let user = userRepository.getUser() else {
            message = "User session not found. Please login again."
            return
        }

        isLoading = true

        Task {

            do {

                let response =
                    try await changePasswordUseCase.execute(
                        username: user.loginId,
                        oldPassword: currentPassword,
                        newPassword: newPassword,
                        userId: user.userId
                    )

                handleResponse(response)

            } catch {

                isLoading = false
                isSuccess = false
                message =
                    "Unable to change password. Please try again."
                
                print(
                    "CHANGE PASSWORD ERROR:",
                    error
                )
            }
        }
    }

    private func handleResponse(
        _ response: ChangePasswordResponse
    ) {

        isLoading = false

        switch response.returnStatus ?? -999 {

        case 1:

            isSuccess = true
            message = "Password changed successfully."

            currentPassword = ""
            newPassword = ""
            confirmPassword = ""

        case 5:

            isSuccess = false
            message =
                "Password should contain at least 6 characters."

        case 6:

            isSuccess = false
            message =
                "Password should not exceed 16 characters."

        case 8:

            isSuccess = false
            message =
                "Password should contain at least one special character."

        case 9:

            isSuccess = false
            message =
                "Password should contain at least one digit."

        case 0:

            isSuccess = false
            message =
                "New password is same as one of the last passwords."

        case -1:

            isSuccess = false
            message =
                "Incorrect old password."

        default:

            isSuccess = false
            message =
                "Unable to change password. Please try again."
        }
    }
}
