//
//  DuplicateSubscriptionResponse.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 06/10/26.
//

import Foundation

struct DuplicateSubscriptionResponse: Decodable {

    let errorCode: Int?
    let errorMessage: String?
    let duplicateCount: Int?
}
