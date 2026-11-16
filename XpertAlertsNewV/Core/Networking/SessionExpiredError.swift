//
//  SessionExpiredError.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 13/11/26.
//


import Foundation

extension Notification.Name {
    static let sessionExpired = Notification.Name("sessionExpired")
}

struct SessionExpiredError: Error {}
