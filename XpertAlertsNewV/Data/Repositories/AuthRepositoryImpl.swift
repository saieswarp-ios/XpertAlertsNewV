//
//  AuthRepositoryImpl.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//

import Foundation
final class AuthRepositoryImpl: AuthRepository {
    func login(email: String, password: String) {
        print("AuthRepositoryImpl received login request")
        print("email:", email)
        print("password", password)
    }
}
