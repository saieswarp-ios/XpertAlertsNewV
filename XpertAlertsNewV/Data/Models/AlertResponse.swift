//
//  AlertResponse.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/09/26.
//

import Foundation

struct AlertResponse: Decodable {
    
    let alertSendDate: String?
    let subject: String?
    let count: Int?
    let errorCode: Int?
    let alertDefId: Int?
    let groupBy: String?
    let message: String?
    let userName: String?
    let userId: Int?
    let buttonDetails: String?
    let deviceStatus: String?
    let emailStatus: String?
    let aggregateAlertId: String?
    let id : Int?
    let alertId: Int?
    let applicationId: Int?
    let applicationName: String?
    let status: Int?
    
}
