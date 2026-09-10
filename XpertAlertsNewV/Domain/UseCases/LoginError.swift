//
//  LoginError.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 08/09/26.
//

import Foundation

enum LoginError: Error {

    case invalidResponse

    case server(message: String)

    case adminNotAllowed
}
