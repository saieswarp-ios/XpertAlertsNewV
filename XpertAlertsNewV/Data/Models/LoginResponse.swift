//
//  LoginResponse.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 08/09/26.
//

import Foundation
 
struct LoginResponse: Decodable {
    
    let errorMsg: String?
    
    let userTypeId: Int?
    
    let fname: String?
    
    let lname: String?
    
    let loginId : String?
    
    let active : Int?
    
    let id: Int?
    
    let sessionId: String?
    
    let userId: Int?
 
    let pwdExpiryFlag: Int?
    
    let applicationIds: String?
    
}




 

