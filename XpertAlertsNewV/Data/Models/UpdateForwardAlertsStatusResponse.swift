//
//  UpdateForwardAlertsStatusResponse.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 08/10/26.
//

import Foundation

struct UpdateForwardAlertsStatusResponse: Decodable {
    let returnStatus: Int?
    let errorCode: Int?
    let message: String?
}
