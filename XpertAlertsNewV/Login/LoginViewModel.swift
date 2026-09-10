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

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func login() {

        print("Login Tapped")

        errorMessage = nil
        
      loginResult = nil

        if email.isEmpty {
            errorMessage = "Please enter your email"
            return
        }

        if password.isEmpty {
            errorMessage = "Please enter your password"
            return
        }
        
        Task {
            
            isLoading = true
            
            do {
                
                let result = try await loginUseCase.execute(email: email, password: password)
                
                loginResult = result

            }
            
            catch LoginError.adminNotAllowed {
                errorMessage = "Admin user cannot login into this app."
            } catch LoginError.server(let message) {
                errorMessage = message
            } catch {
                print("Login failed:", error)
                
                errorMessage = "Login failed. Please try again."
            }
            
            isLoading = false

        }
       
    }
}
