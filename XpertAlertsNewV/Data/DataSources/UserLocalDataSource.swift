import Foundation

protocol UserLocalDataSource {
    
    func save(user: User)
    
    func getUser() -> User?
    
    func clearUser()
}
