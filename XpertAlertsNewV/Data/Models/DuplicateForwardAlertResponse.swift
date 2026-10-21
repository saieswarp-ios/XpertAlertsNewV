//
//  DuplicateForwardAlertResponse.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/10/26.
//

import Foundation

struct DuplicateForwardAlertResponse: Decodable {
    let duplicateCount: Int?
    let errorCode: Int?
}   
