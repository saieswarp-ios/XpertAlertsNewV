import SwiftUI

import Combine



@MainActor

final class ForwardAlertsViewModel: ObservableObject {



    // MARK: - Dependencies



    private let getApplicationsUseCase:

    GetForwardApplicationsUseCase



    private let getUsersUseCase:

    GetForwardUsersUseCase



    private let getForwardAlertsUseCase:

    GetForwardAlertsUseCase



    private let repository:

    ForwardAlertsRepository



    private let deleteForwardAlertUserUseCase:

    DeleteForwardAlertUserUseCase



    private let updateForwardAlertsStatusUseCase:

    UpdateForwardAlertsStatusUseCase



    private let updateForwardAlertsUserStatusUseCase:

    UpdateForwardAlertsUserStatusUseCase



    private let userRepository:

    UserRepository



    // MARK: - Published Properties



    @Published var applications: [ForwardApplication] = []



    @Published var selectedApplication:

    ForwardApplication?



    @Published var users: [ForwardUser] = []



    @Published var selectedUser:

    ForwardUser?



    @Published var forwardAlerts: [ForwardAlert] = []



    @Published var selectedAlert:

    ForwardAlert?



    @Published var isLoadingApplications = false



    @Published var isLoadingUsers = false



    @Published var isLoadingForwardAlerts = false



    @Published var isLoadingEmail = false



    @Published var selectedEmail: String = ""



    @Published var errorMessage: String?



    // MARK: - Init



    init(

        getApplicationsUseCase:

        GetForwardApplicationsUseCase,



        getUsersUseCase:

        GetForwardUsersUseCase,



        getForwardAlertsUseCase:

        GetForwardAlertsUseCase,



        repository:

        ForwardAlertsRepository,



        deleteForwardAlertUserUseCase:

        DeleteForwardAlertUserUseCase,



        updateForwardAlertsStatusUseCase:

        UpdateForwardAlertsStatusUseCase,

        updateForwardAlertsUserStatusUseCase:

        UpdateForwardAlertsUserStatusUseCase,



        userRepository:

        UserRepository

    ) {



        self.getApplicationsUseCase =

        getApplicationsUseCase



        self.getUsersUseCase =

        getUsersUseCase



        self.getForwardAlertsUseCase =

        getForwardAlertsUseCase



        self.repository =

        repository



        self.deleteForwardAlertUserUseCase =

        deleteForwardAlertUserUseCase



        self.updateForwardAlertsStatusUseCase =

        updateForwardAlertsStatusUseCase

        self.updateForwardAlertsUserStatusUseCase =

        updateForwardAlertsUserStatusUseCase



        self.userRepository =

        userRepository

    }



    // MARK: - Load Applications



    func loadApplications() async {



        isLoadingApplications = true

        errorMessage = nil



        do {



            applications =

            try await getApplicationsUseCase.execute()



            print(

                "========== FORWARD APPLICATIONS =========="

            )



            print(

                "Number of Applications:",

                applications.count

            )



            for application in applications {



                print(

                    "ID:",

                    application.id,

                    "Name:",

                    application.name

                )

            }



            print(

                "=========================================="

            )



        } catch {



            errorMessage =

            error.localizedDescription



            print(

                "GET FORWARD APPLICATIONS ERROR:"

            )



            print(error)

        }



        isLoadingApplications = false

    }



    // MARK: - Select Application



    func selectApplication(

        _ application: ForwardApplication

    ) async {



        selectedApplication =

        application



        selectedUser = nil



        selectedEmail = ""



        users = []



        await loadUsers(

            applicationId:

                application.id

        )

    }



    // MARK: - Load Users



    private func loadUsers(

        applicationId: Int

    ) async {



        isLoadingUsers = true

        errorMessage = nil



        do {



            users =

            try await getUsersUseCase.execute(

                applicationId:

                    applicationId

            )



            print(

                "========== FORWARD USERS =========="

            )



            print(

                "Number of Users:",

                users.count

            )



            for user in users {



                print(

                    "ID:",

                    user.id,

                    "Name:",

                    user.userName

                )

            }



            print(

                "==================================="

            )



        } catch {



            errorMessage =

            error.localizedDescription



            print(

                "GET FORWARD USERS ERROR:"

            )



            print(error)

        }



        isLoadingUsers = false

    }



    // MARK: - Select User



    func selectUser(

        _ user: ForwardUser

    ) {



        selectedUser =

        user



        selectedEmail = ""



        loadUserEmail(

            userId:

                user.id

        )

    }



    // MARK: - Load User Email



    private func loadUserEmail(

        userId: Int

    ) {



        isLoadingEmail = true

        errorMessage = nil



        Task {



            do {



                selectedEmail =

                try await repository.getUserEmail(

                    userId:

                        userId

                )



                print(

                    "SELECTED USER EMAIL:",

                    selectedEmail

                )



            } catch {



                errorMessage =

                error.localizedDescription



                print(

                    "GET USER EMAIL ERROR:"

                )



                print(error)

            }



            isLoadingEmail = false

        }

    }



    // MARK: - Load Forward Alerts



    func loadForwardAlerts() async {



        isLoadingForwardAlerts = true

        errorMessage = nil



        do {



            forwardAlerts =

            try await getForwardAlertsUseCase.execute()



            print(

                "========== FORWARD ALERTS =========="

            )



            print(

                "Number of Forward Alerts:",

                forwardAlerts.count

            )



            for alert in forwardAlerts {



                print(

                    "ID:",

                    alert.id,

                    "User:",

                    alert.userName,

                    "Application:",

                    alert.applicationName,

                    "Email:",

                    alert.email,

                    "Active:",

                    alert.active

                )

            }



            print(

                "===================================="

            )



        } catch {



            errorMessage =

            error.localizedDescription



            print(

                "GET FORWARD ALERTS ERROR:"

            )



            print(error)

        }



        isLoadingForwardAlerts = false

    }



    // MARK: - Delete Forward Alert

    func deleteForwardAlert(_ alert: ForwardAlert) async {



        errorMessage = nil



        guard let user = userRepository.getUser() else {

            errorMessage = "User session not found"

            print("DELETE FAILED: User session not found")

            return

        }



        print("========== DELETE FORWARD ALERT ==========")

        print("Forward Alert ID:", alert.id)

        print("User session available:", !user.sessionId.isEmpty)



        do {

            let response = try await deleteForwardAlertUserUseCase.execute(

                forwardAlertId: alert.id,

                sessionId: user.sessionId

            )



            print("Delete Error Code:", response.errorCode ?? -1)

            print("Delete Message:", response.message ?? "-")



            if response.errorCode == 0 {

                forwardAlerts.removeAll { $0.id == alert.id }



                print("Local removal completed for ID:", alert.id)

                print("Remaining alerts:", forwardAlerts.map { $0.id })

            } else {

                errorMessage = response.message

                    ?? "Unable to delete forward alert"



                print("Backend did not confirm deletion for ID:", alert.id)

            }



        } catch {

            errorMessage = error.localizedDescription

            print("DELETE FORWARD ALERT API FAILED:", error)

        }



        print("==========================================")

    }



    func updateForwardAlertsStatus(status: Int) async {



        errorMessage = nil



        guard let user = userRepository.getUser() else {

            errorMessage = "User session not found"

            return

        }



        do {

            let response = try await updateForwardAlertsStatusUseCase.execute(

                userId: user.userId,

                status: status,

                sessionId: user.sessionId

            )



            print("========== UPDATE FORWARD ALERTS STATUS ==========")

            print("Return Status:", response.returnStatus ?? -1)

            print("Error Code:", response.errorCode ?? -1)

            print("Message:", response.message ?? "-")

            print("===================================================")



            if response.errorCode == 0 {

                await loadForwardAlerts()

            } else {

                errorMessage = response.message

                    ?? "Unable to update forward alerts status"

            }



        } catch {

            errorMessage = error.localizedDescription

            print("UPDATE FORWARD ALERTS STATUS API FAILED:", error)

        }

    }




    // MARK: - Update Individual Forward Alert User Status

    func updateForwardAlertsUserStatus(
        _ alert: ForwardAlert,
        status: Int
    ) async {
        errorMessage = nil

        guard let user = userRepository.getUser() else {
            errorMessage = "User session not found"
            return
        }

        do {
            let response = try await updateForwardAlertsUserStatusUseCase.execute(
                userId: user.userId,
                status: status,
                mappedUserId: alert.mapUserId,
                applicationId: alert.applicationId,
                sessionId: user.sessionId
            )

            print("========== UPDATE FORWARD ALERT USER STATUS ==========")
            print("Return Status:", response.returnStatus ?? -1)
            print("Error Code:", response.errorCode ?? -1)
            print("Status update response received")
            print("=======================================================")

            if response.errorCode == 0 {
                await loadForwardAlerts()
            } else {
                errorMessage = "Unable to update forward alert user status"
            }
        } catch {
            errorMessage = error.localizedDescription
            print("UPDATE FORWARD ALERT USER STATUS API FAILED:", error)
        }
    }

}


