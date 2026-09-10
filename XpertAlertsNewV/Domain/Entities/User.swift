//
//  User.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 08/09/26.
//

import Foundation
struct User: Equatable {
    
   let userId: Int
    
    let loginId: String
    
    let firstName: String
    
    let lastName: String
    
    let sessionId: String
    
    let userTypeId: Int
    
    let active : Int
    
    let passwordExpiryFlag: Int
    
    let applicationIds: String
    
}
