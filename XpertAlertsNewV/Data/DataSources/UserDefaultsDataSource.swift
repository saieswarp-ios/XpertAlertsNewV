//
//  UserDefaultsDataSource.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/09/26.
//

import Foundation

final class UserDefaultsDataSource: UserLocalDataSource {
    
    private let defaults = UserDefaults.standard
    
    private let userIdKey = "userId"
    private let loginIDKey = "loginId"
    private let firstNameKey = "firstName"
    private let lastNameKey = "lastName"
    private let sessionIdKey = "sessionId"
    private let userTypeIdKey = "userTypeId"
    private let activeKey = "active"
    private let passwordExpiryFlagKey = "passwordExpiryFlag"
    private let applicationIdKey = "applicationIds"
    
    func save(user: User) {
            
        defaults.set(user.userId, forKey: userIdKey)
        defaults.set(user.loginId, forKey: loginIDKey)
        defaults.set(user.firstName, forKey: firstNameKey)
        defaults.set(user.lastName, forKey: lastNameKey)
        defaults.set(user.sessionId, forKey: sessionIdKey)
        defaults.set(user.userTypeId, forKey: userTypeIdKey)
        defaults.set(user.active, forKey: activeKey)
        defaults.set(user.passwordExpiryFlag, forKey: passwordExpiryFlagKey)
        defaults.set(user.applicationIds, forKey: applicationIdKey)
        
        
    }
    
    func getUser() -> User? {
        guard defaults.object(forKey: userIdKey) != nil else {
            return nil }
        
        return User (
        userId: defaults.integer(forKey: userIdKey),
         loginId: defaults.string(forKey: loginIDKey) ?? "",
         firstName: defaults.string(forKey: firstNameKey) ?? "",
         lastName: defaults.string(forKey: lastNameKey) ?? "",
         sessionId: defaults.string(forKey: sessionIdKey) ?? "",
         userTypeId: defaults.integer(forKey: userTypeIdKey),
         active: defaults.integer(forKey: activeKey),
         passwordExpiryFlag: defaults.integer(forKey: passwordExpiryFlagKey),
         applicationIds: defaults.string(forKey: applicationIdKey) ?? ""
         
        
        
        )
        
    }
    
    func clearUser() {
        defaults.removeObject(forKey: userIdKey)
        defaults.removeObject(forKey: loginIDKey)
        defaults.removeObject(forKey: firstNameKey)
        defaults.removeObject(forKey: lastNameKey)
        defaults.removeObject(forKey: sessionIdKey)
        defaults.removeObject(forKey: userIdKey)
        defaults.removeObject(forKey: activeKey)
        defaults.removeObject(forKey: passwordExpiryFlagKey)
        defaults.removeObject(forKey: applicationIdKey)
        
        
    }
    
    
}
