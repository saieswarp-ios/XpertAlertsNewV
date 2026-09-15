import Foundation

final class UserDefaultsSearchDataSource: SearchLocalDataSource {

    private let defaults = UserDefaults.standard

    private let applicationIdKey =
        "AlertApplicationID"

    private let startDateKey =
        "AlertStartDate"

    private let endDateKey =
        "AlertEndDate"



    func saveApplicationId(_ applicationId: Int) {

        defaults.set(
            applicationId,
            forKey: applicationIdKey
        )

        print(
            "Saved Application ID:",
            applicationId
        )
    }

    func getApplicationId() -> Int {

        return defaults.integer(
            forKey: applicationIdKey
        )
    }


 

    func saveStartDate(_ date: String) {

        defaults.set(
            date,
            forKey: startDateKey
        )

        print(
            "Saved Start Date:",
            date
        )
    }

    func getStartDate() -> String {

        return defaults.string(
            forKey: startDateKey
        ) ?? ""
    }




    func saveEndDate(_ date: String) {

        defaults.set(
            date,
            forKey: endDateKey
        )

        print(
            "Saved End Date:",
            date
        )
    }

    func getEndDate() -> String {

        return defaults.string(
            forKey: endDateKey
        ) ?? ""
    }
}
