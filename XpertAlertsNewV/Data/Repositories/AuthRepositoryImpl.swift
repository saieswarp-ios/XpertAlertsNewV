import Foundation
import UIKit

final class AuthRepositoryImpl: AuthRepository {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func login(
        email: String,
        password: String
    ) async throws -> User {

        let endpoint =
            APIEndpoint.baseURL +
            APIEndpoint.login

        let deviceId =
            UIDevice.current.identifierForVendor?.uuidString ?? ""

        let queryItems = [
            URLQueryItem(
                name: "username",
                value: email
            ),

            URLQueryItem(
                name: "password",
                value: password
            ),

            URLQueryItem(
                name: "deviceId",
                value: deviceId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        let response = try JSONDecoder().decode(
            [LoginResponse].self,
            from: data
        )

        guard let loginResponse = response.first else {
            throw LoginError.invalidResponse
        }

        if let errorMessage = loginResponse.errorMsg,
           !errorMessage.isEmpty {

            throw LoginError.server(
                message: errorMessage
            )
        }

        guard
            let userId = loginResponse.userId,
            let loginId = loginResponse.loginId,
            let firstName = loginResponse.fname,
            let lastName = loginResponse.lname,
            let sessionId = loginResponse.sessionId,
            let userTypeId = loginResponse.userTypeId,
            let active = loginResponse.active,
            let passwordExpiryFlag = loginResponse.pwdExpiryFlag,
            let applicationIds = loginResponse.applicationIds
        else {
            throw LoginError.invalidResponse
        }

        return User(
            userId: userId,
            loginId: loginId,
            firstName: firstName,
            lastName: lastName,
            sessionId: sessionId,
            userTypeId: userTypeId,
            active: active,
            passwordExpiryFlag: passwordExpiryFlag,
            applicationIds: applicationIds
        )
    }
}
