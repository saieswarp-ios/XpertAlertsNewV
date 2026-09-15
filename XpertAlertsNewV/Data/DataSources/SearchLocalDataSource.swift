//
//  SearchLocalDataSource.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 10/09/26.
//

import Foundation

protocol SearchLocalDataSource {
    func saveApplicationId(_ applicationId: Int)
    
    func getApplicationId() -> Int
    
    func saveStartDate(_ date: String)
      func getStartDate() -> String

      func saveEndDate(_ date: String)
      func getEndDate() -> String
}
