//
//  Alert.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/09/26.
//

import Foundation

struct Alert: Identifiable, Equatable{
    
    let id: Int
    let alertId: Int
    let alertDefId: Int
    let userid: Int
    let applicationId: Int
    let subject: String
    let message: String
    let date: String
    let applicationName: String
    let username: String
    let groupBy: String
    let aggregateAlertId: String
    
    let count: Int
    let status: Int
}
