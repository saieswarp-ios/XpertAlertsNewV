//
//  ForwardAlertsRepositoryImpl.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 28/09/26.
//
import Foundation

final class ForwardAlertsRepositoryImpl: ForwardAlertsRepository {

    private let apiClient: APIClient
    private let userRepository: UserRepository

    init(
        apiClient: APIClient,
        userRepository: UserRepository
    ) {
        self.apiClient = apiClient
        self.userRepository = userRepository
    }

    // MARK: - Get Applications

    func getApplications() async throws -> [ForwardApplication] {

        guard let user = userRepository.getUser() else {
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint =
            APIEndpoint.baseURL +
            "getApplicationList"

        let queryItems = [
            URLQueryItem(
                name: "userId",
                value: String(user.userId)
            ),
            URLQueryItem(
                name: "userTypeId",
                value: String(user.userTypeId)
            ),
            URLQueryItem(
                name: "sessionId",
                value: user.sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        let response = try JSONDecoder().decode(
            [ApplicationListResponseModel].self,
            from: data
        )

        return response.compactMap { item in

            guard
                let id = item.id,
                let name = item.name
            else {
                return nil
            }

            return ForwardApplication(
                id: id,
                name: name
            )
        }
    }

    // MARK: - Get Users

    func getUsers(
        applicationId: Int?
    ) async throws -> [ForwardUser] {

        guard let user = userRepository.getUser() else {
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint =
            APIEndpoint.baseURL +
            "getBaseUserList"

        let applicationValue =
            applicationId.map(String.init) ?? ""

        let queryItems = [
            URLQueryItem(
                name: "userId",
                value: String(user.userId)
            ),
            URLQueryItem(
                name: "userTypeId",
                value: String(user.userTypeId)
            ),
            URLQueryItem(
                name: "applicationIds",
                value: applicationValue
            ),
            URLQueryItem(
                name: "sessionId",
                value: user.sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        let response = try JSONDecoder().decode(
            [UserListResponseModel].self,
            from: data
        )

        return response.compactMap { item in

            guard
                let id = item.userID,
                let userName = item.userName
            else {
                return nil
            }

            return ForwardUser(
                id: id,
                userName: userName
            )
        }
    }

    // MARK: - Get User Email

//    func getUserEmail(
//        userId: Int
//    ) async throws -> String {
//
//        guard let user = userRepository.getUser() else {
//            throw URLError(.userAuthenticationRequired)
//        }
//
//        let endpoint =
//            APIEndpoint.baseURL +
//            "getUserEmail"
//
//        let queryItems = [
//            URLQueryItem(
//                name: "userId",
//                value: String(userId)
//            ),
//            URLQueryItem(
//                name: "sessionId",
//                value: user.sessionId
//            )
//        ]
//
//        let data = try await apiClient.request(
//            endpoint: endpoint,
//            method: "GET",
//            queryItems: queryItems
//        )
//
//        let response = try JSONDecoder().decode(
//            [EmailResponseModel].self,
//            from: data
//        )
//
//        guard
//            let email = response.first?.mailId,
//            !email.isEmpty
//        else {
//            throw URLError(.cannotParseResponse)
//        }
//
//        return email
//    }

    
    
    func getUserEmail(userId: Int) async throws -> String {
        guard let user = userRepository.getUser() else {
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint = APIEndpoint.baseURL + "getUserEmail"

        let queryItems = [
            URLQueryItem(name: "userId", value: String(userId)),
            URLQueryItem(name: "sessionId", value: user.sessionId)
        ]

        print("GET USER EMAIL: starting request for user ID \(userId)")

        let data: Data

        do {
            data = try await apiClient.request(
                endpoint: endpoint,
                method: "GET",
                queryItems: queryItems
            )
            print(
                "GET USER EMAIL RAW RESPONSE:",
                String(data: data, encoding: .utf8) ?? "Unable to read response"
            )
        } catch {
            let nsError = error as NSError
            print("GET USER EMAIL: REQUEST FAILED")
            print("Error domain: \(nsError.domain)")
            print("Error code: \(nsError.code)")
            print("Error description: \(nsError.localizedDescription)")
            throw error
        }

        do {
            let response = try JSONDecoder().decode(
                [EmailResponseModel].self,
                from: data
            )

         
            guard let firstResponse = response.first else {
                throw URLError(.cannotParseResponse)
            }

            guard let email = firstResponse.mailId, !email.isEmpty else {
                throw NSError(
                    domain: "GetUserEmail",
                    code: 1,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            firstResponse.message ?? "No email address was returned for this user."
                    ]
                )
            }

            return email

        } catch {
            print("GET USER EMAIL: RESPONSE DECODING FAILED")
            print("Error:", error)
            throw error
        }
    }

    // MARK: - Get Forward Alerts

    func getForwardAlerts() async throws -> [ForwardAlert] {

        guard let user = userRepository.getUser() else {
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint =
            APIEndpoint.baseURL +
            "getForwardAlertsList"

        let queryItems = [

            URLQueryItem(
                name: "baseUserId",
                value: String(user.userId)
            ),

            URLQueryItem(
                name: "lowerBound",
                value: "0"
            ),

            URLQueryItem(
                name: "upperBound",
                value: "100"
            ),

            URLQueryItem(
                name: "searchName",
                value: ""
            ),

            URLQueryItem(
                name: "applicationIds",
                value: user.applicationIds
            ),

            URLQueryItem(
                name: "searchEmail",
                value: ""
            ),

            URLQueryItem(
                name: "searchActive",
                value: String(user.active)
            ),

            URLQueryItem(
                name: "searchAppId",
                value: "0"
            ),

            URLQueryItem(
                name: "sessionId",
                value: user.sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        let response = try JSONDecoder().decode(
            [ForwardAlertsResponseModel].self,
            from: data
        )

        return response.compactMap { item in

            guard
                let id = item.forwardAlertID,
                let userName = item.userName,
                let applicationName = item.applicationName,
                let email = item.email,
                let applicationId = item.applicationID,
                let mapUserId = item.mapUserID,
                let active = item.active
            else {
                return nil
            }

            return ForwardAlert(
                id: id,
                userName: userName,
                applicationName: applicationName,
                email: email,
                applicationId: applicationId,
                mapUserId: mapUserId,
                active: active
            )
        }
    }

    // MARK: - Save Mapped User

    func saveMappedUser(
        mappedUserId: Int,
        applicationId: Int,
        email: String,
        sortOrder: Int,
        active: Int
    ) async throws -> SaveMappedUserResponse {

        guard let user = userRepository.getUser() else {
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint =
            APIEndpoint.baseURL +
            "saveMappedUsers"

        let queryItems = [

            URLQueryItem(
                name: "forwardAlertId",
                value: "0"
            ),

            URLQueryItem(
                name: "baseUserId",
                value: String(user.userId)
            ),

            URLQueryItem(
                name: "mappedUserId",
                value: String(mappedUserId)
            ),

            URLQueryItem(
                name: "email",
                value: email
            ),

            URLQueryItem(
                name: "sortOrder",
                value: String(sortOrder)
            ),

            URLQueryItem(
                name: "active",
                value: String(active)
            ),

            URLQueryItem(
                name: "applicationId",
                value: String(applicationId)
            ),

            URLQueryItem(
                name: "sessionId",
                value: user.sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        let response = try JSONDecoder().decode(
            [SaveMappedUserResponse].self,
            from: data
        )

        guard let firstResponse = response.first else {
            throw URLError(.cannotParseResponse)
        }

        return firstResponse
    }
    
    
    
    
    
    // MARK: - Delete Forward Alert User

    func deleteForwardAlertUser(
        forwardAlertId: Int,
        sessionId: String
    ) async throws -> DeleteForwardAlertUserResponse {

        guard let user = userRepository.getUser() else {
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint =
            APIEndpoint.baseURL +
            "deleteForwardAlertUser"

        let queryItems = [

            URLQueryItem(
                name: "forwardAlertId",
                value: String(forwardAlertId)
            ),

            URLQueryItem(
                name: "sessionId",
                value: sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        let response = try JSONDecoder().decode(
            [DeleteForwardAlertUserResponse].self,
            from: data
        )

        guard let firstResponse = response.first else {
            throw URLError(.cannotParseResponse)
        }

        return firstResponse
    }
    
    
    func duplicateForwardAlert(
        forwardAlertId: Int,
        mappedUserId: Int,
        applicationId: Int,
        sessionId: String
    ) async throws -> DuplicateForwardAlertResponse {

        let endpoint =
            APIEndpoint.baseURL +
            "duplicateForwardAlert"

        let queryItems = [
            URLQueryItem(
                name: "forwardAlertId",
                value: String(forwardAlertId)
            ),
            URLQueryItem(
                name: "baseUserId",
                value: String(
                    userRepository.getUser()?.userId ?? 0
                )
            ),
            URLQueryItem(
                name: "mappedUserId",
                value: String(mappedUserId)
            ),
            URLQueryItem(
                name: "applicationId",
                value: String(applicationId)
            ),
            URLQueryItem(
                name: "sessionId",
                value: sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        let response = try JSONDecoder().decode(
            [DuplicateForwardAlertResponse].self,
            from: data
        )

        guard let firstResponse = response.first else {
            throw URLError(.cannotParseResponse)
        }

        return firstResponse
    }
    
    
    func updateForwardAlertsStatus(
        userId: Int,
        status: Int,
        sessionId: String
    ) async throws -> UpdateForwardAlertsStatusResponse {

        let endpoint =
            APIEndpoint.baseURL +
            "updateForwardAlertsStatus"

        let queryItems = [
            URLQueryItem(
                name: "userId",
                value: String(userId)
            ),
            URLQueryItem(
                name: "status",
                value: String(status)
            ),
            URLQueryItem(
                name: "sessionId",
                value: sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )

        let response = try JSONDecoder().decode(
            [UpdateForwardAlertsStatusResponse].self,
            from: data
        )

        guard let firstResponse = response.first else {
            throw URLError(.cannotParseResponse)
        }

        return firstResponse
    }
    
    func updateForwardAlertsUserStatus(
        userId: Int,
        status: Int,
        mappedUserId: Int,
        applicationId: Int,
        sessionId: String
    ) async throws -> UpdateForwardAlertsUserStatusResponse {

        let endpoint =
            APIEndpoint.baseURL +
            "updateForwardAlertsUserStatus"

        let queryItems = [
            URLQueryItem(
                name: "userId",
                value: String(userId)
            ),
            URLQueryItem(
                name: "status",
                value: String(status)
            ),
            URLQueryItem(
                name: "mappedUserId",
                value: String(mappedUserId)
            ),
            URLQueryItem(
                name: "applicationId",
                value: String(applicationId)
            ),
            URLQueryItem(
                name: "sessionId",
                value: sessionId
            )
        ]

        let data = try await apiClient.request(
            endpoint: endpoint,
            method: "GET",
            queryItems: queryItems
        )
        print("FORWARD USERS RESPONSE:")
        print(String(data: data, encoding: .utf8) ?? "Unable to read response")
        

        let response = try JSONDecoder().decode(
            [UpdateForwardAlertsUserStatusResponse].self,
            from: data
        )

        guard let firstResponse = response.first else {
            throw URLError(.cannotParseResponse)
        }

        return firstResponse
    }
    
}
    
