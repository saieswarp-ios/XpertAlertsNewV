//
//  LoginUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//
import Foundation
final class LoginUseCase {
    
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(
        email: String, password: String) -> Bool {
            
            print("loginUsecase execute called here")
            return authRepository.login(
                email: email,
                password: password
                ) 
        }
    
}








