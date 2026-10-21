//
//  ProcessDynamicActionsResponse.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/10/26.
//

import Foundation

struct ProcessDynamicActionsResponse: Decodable {
    let returnFlag: Int?
    let errorCode: Int?
    let message: String?
}
