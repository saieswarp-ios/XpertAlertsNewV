//
//  Subscription.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

struct Subscription: Identifiable, Decodable {

    let id: Int
    let alertName: String?
    let alertFlag: Int?
    let count: Int?
    let active: Int?
    let errorCode: Int?
    let applicationId: Int?
    let alertDefinitionName: String?
    let device: String?
    let applicationName: String?
    let email: String?

    enum CodingKeys: String, CodingKey {

        case id = "userSubId"
        case alertName = "alerName"
        case alertFlag
        case count
        case active
        case errorCode
        case applicationId = "applicationId"
        case alertDefinitionName = "alertDefName"
        case device
        case applicationName
        case email
    }
}
