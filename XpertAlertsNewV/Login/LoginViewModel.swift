
import SwiftUI
import Combine

@MainActor
final class LoginViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var loginResult: LoginResult?

    private let loginUseCase: LoginUseCase
    //private let analyticsTracker: AnalyticsTracking

    init(
        loginUseCase: LoginUseCase
        //,
       // analyticsTracker: AnalyticsTracking
    ) {
        self.loginUseCase = loginUseCase
        //self.analyticsTracker = analyticsTracker
    }

    func login() {
        errorMessage = nil
        loginResult = nil

        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }

        guard !password.isEmpty else {
            errorMessage = "Please enter your password"
            return
        }

       // analyticsTracker.trackEvent("login_attempt", parameters: nil)

        Task {
            isLoading = true

            defer {
                isLoading = false
            }

            do {
                let result = try await loginUseCase.execute(
                    email: email,
                    password: password
                )

                loginResult = result

               // analyticsTracker.trackEvent("login_success", parameters: nil)
            } catch LoginError.adminNotAllowed {
                errorMessage = "Admin user cannot login into this app."

//                //analyticsTracker.trackEvent(
//                    "login_failure",
//                    parameters: ["reason": "admin_not_allowed"]
//                )
            } catch LoginError.server(let message) {
                errorMessage = message

//                //analyticsTracker.trackEvent(
//                    "login_failure",
//                    parameters: ["reason": "server_error"]
//                )
            } catch {
                print("Login failed:", error)
                errorMessage = "Login failed. Please try again."

//                analyticsTracker.trackEvent(
//                    "login_failure",
//                    parameters: ["reason": "unexpected_error"]
//                )
            }
        }
    }
}

