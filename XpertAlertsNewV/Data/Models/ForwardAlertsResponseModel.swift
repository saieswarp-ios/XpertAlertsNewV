//
//  ForwardAlertsResponseModel.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 29/09/26.
//

import Foundation

struct ForwardAlertsResponseModel: Codable {

    let forwardAlertID: Int?
    let sortOrder: Int?
    let active: Int?
    let errorCode: Int?

    let userName: String?

    let applicationID: Int?
    let mapUserID: Int?

    let email: String?
    let applicationName: String?

    let message: String?

    enum CodingKeys: String, CodingKey {

        case forwardAlertID = "forwardAlertId"
        case sortOrder
        case active
        case errorCode
        case userName

        case applicationID = "applicationId"
        case mapUserID = "mapUserId"

        case email
        case applicationName
        case message
    }
}
