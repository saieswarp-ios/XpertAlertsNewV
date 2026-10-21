//
//  AnalyticsTracking.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 21/10/26.
//

import Foundation

protocol AnalyticsTracking {
    func trackEvent(
        _ name: String,
        parameters: [String: Any]?
    )
}

