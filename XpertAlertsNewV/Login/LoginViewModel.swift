import SwiftUI
import Combine

@MainActor
final class LoginViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func login() {

        print("Login Tapped")

        errorMessage = nil

        if email.isEmpty {
            errorMessage = "Please enter your email"
            return
        }

        if password.isEmpty {
            errorMessage = "Please enter your password"
            return
        }

        loginUseCase.execute(
            email: email,
            password: password
        )
    }
}
