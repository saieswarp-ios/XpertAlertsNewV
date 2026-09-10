//
//  LogoutUseCase.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/09/26.
//

import Foundation

final class LogoutUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute() {
        userRepository.clearUser()
    }
}
