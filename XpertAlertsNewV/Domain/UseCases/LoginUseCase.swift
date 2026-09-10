//
//  LoginUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//
import Foundation
final class LoginUseCase {
    
    
    private let authRepository: AuthRepository
    
    private let userRepository: UserRepository
    
    init(authRepository: AuthRepository,
         userRepository: UserRepository) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    func execute(
            
        email: String, password: String) async throws -> LoginResult {  // async : this operation may take some time, so dont block the uii while waiting
            
            print("loginUsecase execute called here")
            
            let user = try await authRepository.login(
                
                email: email,
                password: password
                
            )
            
            // Admin users cannot login into this app.
                if user.userTypeId == 1 || user.userTypeId == 2 {
                    throw LoginError.adminNotAllowed
                }

            userRepository.saveUser(user)
            print("Application IDs:", user.applicationIds)
            
                // Password has expired.
                if user.passwordExpiryFlag != 0 {
                    return .passwordExpired(user)
                }

                // Normal successful login.
                return .success(user)
        }
    
}








