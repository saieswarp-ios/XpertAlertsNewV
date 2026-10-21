//
//  ArchivedRepository.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 25/09/26.
//

import Foundation

protocol ArchivedRepository {

    func getArchivedAlerts(
        startDate: String,
        endDate: String,
        searchByKeyword: String,
        viewByFlag: Int,
        status: Int,
        emailStatus: Int
    ) async throws -> [Alert]
}
