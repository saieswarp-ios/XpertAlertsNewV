
import Foundation

struct APIEndpoint {

    // MARK: - Default Base URL

//    static let defaultBaseURL =
//        "https://testapps.aquilasoftware.com/ams/webservice/"
    static let defaultBaseURL =
        "https://www.xpertalerts.com/ams/webservice/"

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
    
    static let saveFCMToken =
        "saveTokenDetails"
  
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
//dhjfguiyaweg
