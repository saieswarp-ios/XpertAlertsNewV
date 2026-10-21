import Foundation

protocol ForwardAlertsRepository {

    func getApplications() async throws -> [ForwardApplication]

    func getUsers(
        applicationId: Int?
    ) async throws -> [ForwardUser]

    func getUserEmail(
        userId: Int
    ) async throws -> String

    func getForwardAlerts() async throws -> [ForwardAlert]
    
    func saveMappedUser(
        mappedUserId: Int,
        applicationId: Int,
        email: String,
        sortOrder: Int,
        active: Int
    ) async throws -> SaveMappedUserResponse
    
    
    func deleteForwardAlertUser(
        forwardAlertId: Int,
        sessionId: String
    ) async throws -> DeleteForwardAlertUserResponse
    
    func duplicateForwardAlert(
        forwardAlertId: Int,
        mappedUserId: Int,
        applicationId: Int,
        sessionId: String
    ) async throws -> DuplicateForwardAlertResponse
    
    func updateForwardAlertsStatus(
        userId: Int,
        status: Int,
        sessionId: String
    ) async throws -> UpdateForwardAlertsStatusResponse
    
    func updateForwardAlertsUserStatus(
        userId: Int,
        status: Int,
        mappedUserId: Int,
        applicationId: Int,
        sessionId: String
    ) async throws -> UpdateForwardAlertsUserStatusResponse
}
