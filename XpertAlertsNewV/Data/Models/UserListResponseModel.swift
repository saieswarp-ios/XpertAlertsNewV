//
//  UserListResponseModel.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 28/09/26.
//

import Foundation

struct UserListResponseModel: Codable {
    let errorCode: Int?
    let message: String?
    let userName: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case errorCode
        case message
        case userName
        case userID = "userId"
    }
}
