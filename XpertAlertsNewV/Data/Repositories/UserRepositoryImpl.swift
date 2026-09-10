//
//  UserRepositoryImpl.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 09/09/26.
//

import Foundation

final class UserRepositoryImpl: UserRepository {
  
    
    
    private let localDataSource: UserLocalDataSource
    
    init(localDataSource: UserLocalDataSource) {
        self.localDataSource = localDataSource
    }
    
    func saveUser(_ user: User) {
        localDataSource.save(user: user)
    }
    
    func getUser() -> User? {
        return localDataSource.getUser()
    }
    
    func clearUser() {
        localDataSource.clearUser()
    }
    
    
}
