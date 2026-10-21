//
//  ApplicationResponse.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 24/09/26.
//

import Foundation

struct ApplicationResponse: Decodable {
    let name: String?
    let errorCode: Int?
    let id: Int?
    let message: String?
}
