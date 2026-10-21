////
////  APIEndpoint.swift
////  XpertAlertsNewV
////
////  Created by IOS DEV on 08/09/26.
////
//
////import Foundation
////
////struct APIEndpoint {
////    static let baseURL = "https://testapps.aquilasoftware.com/ams/webservice/"
////
////    static let login = "authenticateUserForDevices"
////  static let alerts = "getAlertsForDevices"
////    static let archivedAlerts =
////        "getArchivedAlertsForDevices"
////}
//
//
//import Foundation
//
//struct APIEndpoint {
//
//    static let defaultBaseURL =
//        "https://testapps.aquilasoftware.com/ams/webservice/"
//
//    static var baseURL: String {
//
//        let savedURL = UserDefaults.standard.string(
//            forKey: "BaseURL"
//        )
//
//        if let savedURL,
//           !savedURL.trimmingCharacters(
//                in: .whitespacesAndNewlines
//           ).isEmpty {
//
//            return savedURL.hasSuffix("/")
//                ? savedURL
//                : savedURL + "/"
//        }
//
//        return defaultBaseURL
//    }
//
//    static let login =
//        "authenticateUserForDevices"
//
//    static let alerts =
//        "getAlertsForDevices"
//
//    static let archivedAlerts =
//        "getArchivedAlertsForDevices"
//}
//

//import Foundation
//
//struct APIEndpoint {
//
//    // Default URL
//    static let defaultBaseURL =
//        "https://testapps.aquilasoftware.com/ams/webservice/"
//
//    // URL saved from Build Settings
//    static var baseURL: String {
//
//        let savedURL = UserDefaults.standard.string(
//            forKey: "BaseURL"
//        )
//
//        if let savedURL,
//            !savedURL.trimmingCharacters(
//                in: .whitespacesAndNewlines
//            ).isEmpty
//        {
//
//            return savedURL.hasSuffix("/")
//                ? savedURL
//                : savedURL + "/"
//        }
//
//        return defaultBaseURL
//    }
//
//    // API endpoints
//    static let login = "authenticateUserForDevices"
//    static let applications = "getApplicationList"
//    static let alerts = "getAlertsForDevices"
//    static let archivedAlerts = "getArchivedAlertsForDevices"
//}


import Foundation

struct APIEndpoint {

    // MARK: - Default Base URL

    static let defaultBaseURL =
        "https://testapps.aquilasoftware.com/ams/webservice/"

    // MARK: - Base URL

    static var baseURL: String {

        let savedURL = UserDefaults.standard.string(
            forKey: "BaseURL"
        )

        if let savedURL,
           !savedURL.trimmingCharacters(
                in: .whitespacesAndNewlines
           ).isEmpty {

            return savedURL.hasSuffix("/")
                ? savedURL
                : savedURL + "/"
        }

        return defaultBaseURL
    }

    // MARK: - API Endpoints

    static let login =
        "authenticateUserForDevices"

    static let applications =
        "getApplicationList"

    static let alerts =
        "getAlertsForDevices"
  
    static let alertButtonDetails =
        "getAlertButtonDetails"
    static let processDynamicActions = "processDynamicActions"
   

    static let archivedAlerts =
        "getArchivedAlertsForDevices"
    static let changePassword = "saveChangePassword"
    static let subscriptions = "getUserSubscriptionList"
    static let subscriptionDetails = "getUserSubDetailsById"
    static let checkDuplicateSubscription =
        "checkDuplicateUserSubscribe"
    static let alertDefinitions =
        "getAlertDefinitionList"
    static let saveSubscription =
        "saveUserSubscription"
}
