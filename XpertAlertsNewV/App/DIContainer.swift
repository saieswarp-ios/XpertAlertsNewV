import Foundation

final class DIContainer {
  
   // Core

    let apiClient: APIClient
    
   

    // Repositories

    let authRepository: AuthRepository
    let userRepository: UserRepository
    let alertRepository: AlertRepository
    let applicationRepository: ApplicationRepository
    let changePasswordRepository: ChangePasswordRepository

    let subscriptionRepository: SubscriptionRepository
    let getSubscriptionDetailsUseCase:
        GetSubscriptionDetailsUseCase

    let saveSubscriptionUseCase:
        SaveSubscriptionUseCase

    let getDuplicateSubscriptionUseCase:
        GetDuplicateSubscriptionUseCase

    let alertDefinitionRepository:
        AlertDefinitionRepository

    let saveMappedUserUseCase:
        SaveMappedUserUseCase

    let deleteForwardAlertUserUseCase:
        DeleteForwardAlertUserUseCase

    let duplicateForwardAlertUseCase:
        DuplicateForwardAlertUseCase
    let updateForwardAlertsStatusUseCase:
        UpdateForwardAlertsStatusUseCase
    let updateForwardAlertsUserStatusUseCase:
        UpdateForwardAlertsUserStatusUseCase
    
    

    private let forwardAlertsRepository:
        ForwardAlertsRepository

    private let searchRepository:
        SearchRepository

    private let getForwardApplicationsUseCase:
        GetForwardApplicationsUseCase

    private let getForwardUsersUseCase:
        GetForwardUsersUseCase

    private let getForwardAlertsUseCase:
        GetForwardAlertsUseCase

  
    
    

    // Use Cases

    let loginUseCase:
        LoginUseCase

    let logoutUseCase:
        LogoutUseCase

    let getSavedUserUseCase:
        GetSavedUserUseCase

    let getAlertsUseCase:
        GetAlertsUseCase
    
    let getAlertButtonDetailsUseCase:
        GetAlertButtonDetailsUseCase
    
    let processDynamicActionsUseCase: ProcessDynamicActionsUseCase

    let getApplicationsUseCase:
        GetApplicationsUseCase

    let changePasswordUseCase:
        ChangePasswordUseCase

    let getSubscriptionsUseCase:
        GetSubscriptionsUseCase

    let getAlertDefinitionsUseCase:
        GetAlertDefinitionsUseCase

    private let saveSearchApplicationUseCase:
        SaveSearchApplicationUseCase

    let getSearchApplicationUseCase:
        GetSearchApplicationUseCase

    private let saveSearchDatesUseCase:
        SaveSearchDatesUseCase

    let getSearchDatesUseCase:
        GetSearchDatesUseCase

    let archivedRepository:
        ArchivedRepository

    let getArchivedAlertsUseCase:
        GetArchivedAlertsUseCase

    // Init

    init() {

        //  API Client

        self.apiClient =
            URLSessionAPIClient()
        
     

        //  User Repository

        let userLocalDataSource =
            UserDefaultsDataSource()

        self.userRepository =
            UserRepositoryImpl(
                localDataSource:
                    userLocalDataSource
            )

        //  Auth Repository

        self.authRepository =
            AuthRepositoryImpl(
                apiClient:
                    apiClient
            )

        //Change Password Repository

        self.changePasswordRepository =
            ChangePasswordRepositoryImpl(
                apiClient:
                    apiClient
            )

        //  Subscription Repository

        self.subscriptionRepository =
            SubscriptionRepositoryImpl(
                apiClient:
                    apiClient
            )

        // Subscription Use Cases

        self.getSubscriptionDetailsUseCase =
            GetSubscriptionDetailsUseCase(
                repository:
                    subscriptionRepository
            )

        self.saveSubscriptionUseCase =
            SaveSubscriptionUseCase(
                repository:
                    subscriptionRepository
            )

        // Alert Definition Repository

        self.alertDefinitionRepository =
            AlertDefinitionRepositoryImpl(
                apiClient:
                    apiClient
            )

        //  Application Repository

        self.applicationRepository =
            ApplicationRepositoryImpl(
                apiClient:
                    apiClient,
                userRepository:
                    userRepository
            )

        //  Forward Alerts Repository

        self.forwardAlertsRepository =
            ForwardAlertsRepositoryImpl(
                apiClient:
                    apiClient,
                userRepository:
                    userRepository
            )

        // Alert Repository

        self.alertRepository =
            AlertRepositoryImpl(
                apiClient:
                    apiClient,
                userRepository:
                    userRepository
            )

        //  Forward Alerts Use Cases

        self.getForwardApplicationsUseCase =
            GetForwardApplicationsUseCase(
                repository:
                    forwardAlertsRepository
            )

        self.getForwardUsersUseCase =
            GetForwardUsersUseCase(
                repository:
                    forwardAlertsRepository
            )

        self.getForwardAlertsUseCase =
            GetForwardAlertsUseCase(
                repository:
                    forwardAlertsRepository
            )

        //  Update Forward Alerts Status

        self.updateForwardAlertsStatusUseCase =
            UpdateForwardAlertsStatusUseCase(
                repository:
                    forwardAlertsRepository
            )
        
        self.updateForwardAlertsUserStatusUseCase =
            UpdateForwardAlertsUserStatusUseCase(
                repository:
                    forwardAlertsRepository
            )
        

        //  Duplicate Forward Alert

        self.duplicateForwardAlertUseCase =
            DuplicateForwardAlertUseCase(
                repository:
                    forwardAlertsRepository
            )

        //  Change Password Use Case

        self.changePasswordUseCase =
            ChangePasswordUseCase(
                repository:
                    changePasswordRepository
            )

        //  Alert Definitions Use Case

        self.getAlertDefinitionsUseCase =
            GetAlertDefinitionsUseCase(
                alertDefinitionRepository:
                    alertDefinitionRepository
            )

        // Save Mapped User

        self.saveMappedUserUseCase =
            SaveMappedUserUseCase(
                repository:
                    forwardAlertsRepository
            )

        // Delete Forward Alert User

        self.deleteForwardAlertUserUseCase =
            DeleteForwardAlertUserUseCase(
                repository:
                    forwardAlertsRepository
            )

        // Search Repository

        let searchLocalDataSource =
            UserDefaultsSearchDataSource()

        self.searchRepository =
            SearchRepositoryImpl(
                localDataSource:
                    searchLocalDataSource
            )

        // Login Use Case

        self.loginUseCase =
            LoginUseCase(
                authRepository:
                    authRepository,

                userRepository:
                    userRepository,

                searchRepository:
                    searchRepository
            )

        //Logout Use Case

        self.logoutUseCase =
            LogoutUseCase(
                userRepository:
                    userRepository
            )

        //  Saved User Use Case

        self.getSavedUserUseCase =
            GetSavedUserUseCase(
                userRepository:
                    userRepository
            )

        // Alerts Use Case

        self.getAlertsUseCase =
            GetAlertsUseCase(
                alertRepository:
                    alertRepository
            )
        
        
        self.getAlertButtonDetailsUseCase =
            GetAlertButtonDetailsUseCase(
                alertRepository:
                    alertRepository
            )
        
        
        self.processDynamicActionsUseCase =
            ProcessDynamicActionsUseCase(
                alertRepository: alertRepository
            )

        // Applications Use Case

        self.getApplicationsUseCase =
            GetApplicationsUseCase(
                applicationRepository:
                    applicationRepository
            )

        //  Search Application Use Cases

        self.saveSearchApplicationUseCase =
            SaveSearchApplicationUseCase(
                searchRepository:
                    searchRepository
            )

        self.getSearchApplicationUseCase =
            GetSearchApplicationUseCase(
                searchRepository:
                    searchRepository
            )

        // Search Date Use Cases

        self.saveSearchDatesUseCase =
            SaveSearchDatesUseCase(
                searchRepository:
                    searchRepository
            )

        self.getSearchDatesUseCase =
            GetSearchDatesUseCase(
                searchRepository:
                    searchRepository
            )

        //  Archived

        self.archivedRepository =
            ArchivedRepositoryImpl(
                apiClient:
                    apiClient,
                userRepository:
                    userRepository
            )

        self.getArchivedAlertsUseCase =
            GetArchivedAlertsUseCase(
                archivedRepository:
                    archivedRepository
            )

        //  Subscriptions

        self.getSubscriptionsUseCase =
            GetSubscriptionsUseCase(
                repository:
                    subscriptionRepository
            )

        self.getDuplicateSubscriptionUseCase =
            GetDuplicateSubscriptionUseCase(
                repository:
                    subscriptionRepository
            )
    }

//          View Models

   
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            loginUseCase: loginUseCase
            //,
            
        )
    }


    func makeAlertsViewModel() -> AlertsViewModel {

        return AlertsViewModel(
            getAlertsUseCase: getAlertsUseCase,
            getSearchApplicationUseCase: getSearchApplicationUseCase,
            getAlertButtonDetailsUseCase: getAlertButtonDetailsUseCase,
            processDynamicActionsUseCase: processDynamicActionsUseCase
           
        )
    }

    func makeSearchViewModel()
        -> SearchViewModel {

        return SearchViewModel(
            saveSearchApplicationUseCase:
                saveSearchApplicationUseCase,

            getSearchApplicationUseCase:
                getSearchApplicationUseCase,

            saveSearchDatesUseCase:
                saveSearchDatesUseCase,

            getSearchDatesUseCase:
                getSearchDatesUseCase,

            getAlertsUseCase:
                getAlertsUseCase
        )
    }

    //  Logout

    func makeLogoutUseCase()
        -> LogoutUseCase {

        return logoutUseCase
    }

    //  Temporary Application Test

    func testApplications() {

        Task {

            do {

                let applications =
                    try await getApplicationsUseCase
                        .execute()

                print(
                    "========== APPLICATION LIST =========="
                )

                print(
                    "Number of Applications:",
                    applications.count
                )

                for application in applications {

                    print(
                        "Application ID:",
                        application.id,
                        "Name:",
                        application.name
                    )
                }

                print(
                    "======================================"
                )

            } catch {

                print(
                    "APPLICATION API FAILED:"
                )

                print(error)
            }
        }
    }

    func makeArchivedViewModel()
        -> ArchivedViewModel {

        return ArchivedViewModel(
            getArchivedAlertsUseCase:
                getArchivedAlertsUseCase
        )
    }

    func makeForwardAlertsViewModel()
        -> ForwardAlertsViewModel {

        return ForwardAlertsViewModel(
            getApplicationsUseCase:
                getForwardApplicationsUseCase,

            getUsersUseCase:
                getForwardUsersUseCase,

            getForwardAlertsUseCase:
                getForwardAlertsUseCase,

            repository:
                forwardAlertsRepository,

            deleteForwardAlertUserUseCase:
                deleteForwardAlertUserUseCase,

            updateForwardAlertsStatusUseCase:
                updateForwardAlertsStatusUseCase,

            updateForwardAlertsUserStatusUseCase:
                updateForwardAlertsUserStatusUseCase,

            userRepository:
                userRepository
        )
    }
    func makeCreateForwardAlertViewModel()
        -> CreateForwardAlertViewModel {

        return CreateForwardAlertViewModel(
            getApplicationsUseCase:
                getForwardApplicationsUseCase,

            getUsersUseCase:
                getForwardUsersUseCase,

            repository:
                forwardAlertsRepository,

            saveMappedUserUseCase:
                saveMappedUserUseCase,

            duplicateForwardAlertUseCase:
                duplicateForwardAlertUseCase,

            userRepository:
                userRepository
        )
    }

    func makeSubscriptionsViewModel()
        -> SubscriptionsViewModel {

        return SubscriptionsViewModel(
            getSubscriptionsUseCase:
                getSubscriptionsUseCase,

            getSubscriptionDetailsUseCase:
                getSubscriptionDetailsUseCase,

            userRepository:
                userRepository
        )
    }

    func makeGetAlertDefinitionsUseCase()
        -> GetAlertDefinitionsUseCase {

        return getAlertDefinitionsUseCase
    }
    
    func makeSearchAlertsViewModel() -> SearchAlertsViewModel {
        SearchAlertsViewModel(
            getApplicationsUseCase: getApplicationsUseCase,
            getAlertDefinitionsUseCase: getAlertDefinitionsUseCase,
            userRepository: userRepository
        )
    }

}
