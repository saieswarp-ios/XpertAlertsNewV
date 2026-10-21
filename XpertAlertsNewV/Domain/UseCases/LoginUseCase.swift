import Foundation

final class LoginUseCase {

    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    private let searchRepository: SearchRepository

    init(
        authRepository: AuthRepository,
        userRepository: UserRepository,
        searchRepository: SearchRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.searchRepository = searchRepository
    }

    func execute(
        email: String,
        password: String
    ) async throws -> LoginResult {

        print("LoginUseCase.execute() called")

        // 1. Call the login API
        let user = try await authRepository.login(
            email: email,
            password: password
        )

        // 2. Admin users cannot log in to this application
        if user.userTypeId == 1 || user.userTypeId == 2 {
            throw LoginError.adminNotAllowed
        }

        // 3. Save logged-in user
        userRepository.saveUser(user)

        // 4. Print application IDs for debugging
        print("Application IDs:", user.applicationIds)

        // 5. Check password expiry
        if user.passwordExpiryFlag != 0 {
            return .passwordExpired(user)
        }

        // 6. Normal successful login
        return .success(user)
    }
}








