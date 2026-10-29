
import Foundation
import UIKit

final class FCMTokenRegistrationService {

    func registerToken(_ token: String) async {
        guard !token.isEmpty else {
            print("FCM registration skipped: empty token")
            return
        }

        let deviceID =
            UIDevice.current.identifierForVendor?.uuidString ?? ""

        guard !deviceID.isEmpty else {
            print("FCM registration failed: device ID unavailable")
            return
        }

        let endpoint =
            APIEndpoint.baseURL + APIEndpoint.saveFCMToken

        guard var components = URLComponents(string: endpoint) else {
            print("FCM registration failed: invalid URL")
            return
        }

        components.queryItems = [
            URLQueryItem(name: "deviceTypeId", value: "2"),
            URLQueryItem(name: "deviceId", value: deviceID),
            URLQueryItem(name: "tokenId", value: token)
        ]

        guard let url = components.url else {
            print("FCM registration failed: could not build URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        do {
            let (data, response) =
                try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("FCM registration failed: invalid response")
                return
            }

            let responseBody =
                String(data: data, encoding: .utf8) ?? ""

            print(
                "FCM registration HTTP status:",
                httpResponse.statusCode
            )
            print("FCM registration response:", responseBody)

            guard (200...299).contains(httpResponse.statusCode) else {
                print("FCM registration request failed")
                return
            }

            UserDefaults.standard.set(deviceID, forKey: "deviceID")
            print("FCM token registration request succeeded")

        } catch {
            print("FCM registration error:", error.localizedDescription)
        }
    }
}
