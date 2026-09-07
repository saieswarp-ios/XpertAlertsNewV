//
//  AuthRepository.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//

import Foundation
protocol AuthRepository {
    func login(email: String, password: String) -> Bool
}
