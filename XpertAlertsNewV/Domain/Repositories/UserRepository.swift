//
//  UserRepository.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/09/26.
//

import Foundation

protocol UserRepository {
    
    
    func saveUser(_ user: User)
    
    func getUser() -> User?
    
    func clearUser()
}
