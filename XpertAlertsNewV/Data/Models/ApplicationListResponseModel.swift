//
//  ApplicationListResponseModel.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 28/09/26.
//

import Foundation

struct ApplicationListResponseModel: Codable {
    let name: String?
    let errorCode: Int?
    let id: Int?
    let message: String?
}
