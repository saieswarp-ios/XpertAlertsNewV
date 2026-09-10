//
//  LoginResult.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 08/09/26.
//

import Foundation

enum LoginResult: Equatable {

    case success(User)

    case passwordExpired(User)
}
