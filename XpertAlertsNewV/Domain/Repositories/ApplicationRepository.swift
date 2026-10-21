//
//  ApplicationRepository.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 24/09/26.
//

import Foundation

protocol ApplicationRepository {
    func getApplications() async throws -> [Application]
}
