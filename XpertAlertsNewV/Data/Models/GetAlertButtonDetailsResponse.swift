//
//  GetAlertButtonDetailsResponse.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/10/26.
//

import Foundation

struct GetAlertButtonDetailsResponse: Decodable {
    let confirmPrompt: String?
    let AmsActionIds: String?
    let errorCode: Int?
    let actions: String?
    let captions: String?
    let message: String?
}
