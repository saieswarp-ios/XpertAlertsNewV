//
//  ChangePasswordRepository.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

protocol ChangePasswordRepository {

    func changePassword(
        username: String,
        oldPassword: String,
        newPassword: String,
        userId: Int
    ) async throws -> ChangePasswordResponse
}
