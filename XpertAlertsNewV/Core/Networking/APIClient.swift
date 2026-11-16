//
//  APIClient.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 08/09/26.
//

import Foundation
protocol APIClient {
    func request (
        endpoint: String,
        method: String,
        queryItems: [URLQueryItem]
        
    ) async throws -> Data
}
