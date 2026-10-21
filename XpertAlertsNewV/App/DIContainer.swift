import Foundation

final class DIContainer {

    // MARK: - Core

    let apiClient: APIClient
    
    //let analyticsTracker: AnalyticsTracking

    // MARK: - Repositories

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

  
    
    

    // MARK: - Use Cases

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

    // MARK: - Init

    init() {

        // MARK: API Client

        self.apiClient =
            URLSessionAPIClient()
        
        //self.analyticsTracker = FirebaseAnalyticsTracker()

        // MARK: User Repository

        let userLocalDataSource =
            UserDefaultsDataSource()

        self.userRepository =
            UserRepositoryImpl(
                localDataSource:
                    userLocalDataSource
            )

        // MARK: Auth Repository

        self.authRepository =
            AuthRepositoryImpl(
                apiClient:
                    apiClient
            )

        // MARK: Change Password Repository

        self.changePasswordRepository =
            ChangePasswordRepositoryImpl(
                apiClient:
                    apiClient
            )

        // MARK: Subscription Repository

        self.subscriptionRepository =
            SubscriptionRepositoryImpl(
                apiClient:
                    apiClient
            )

        // MARK: Subscription Use Cases

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

        // MARK: Alert Definition Repository

        self.alertDefinitionRepository =
            AlertDefinitionRepositoryImpl(
                apiClient:
                    apiClient
            )

        // MARK: Application Repository

        self.applicationRepository =
            ApplicationRepositoryImpl(
                apiClient:
                    apiClient,
                userRepository:
                    userRepository
            )

        // MARK: Forward Alerts Repository

        self.forwardAlertsRepository =
            ForwardAlertsRepositoryImpl(
                apiClient:
                    apiClient,
                userRepository:
                    userRepository
            )

        // MARK: Alert Repository

        self.alertRepository =
            AlertRepositoryImpl(
                apiClient:
                    apiClient,
                userRepository:
                    userRepository
            )

        // MARK: Forward Alerts Use Cases

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

        // MARK: Update Forward Alerts Status

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
        

        // MARK: Duplicate Forward Alert

        self.duplicateForwardAlertUseCase =
            DuplicateForwardAlertUseCase(
                repository:
                    forwardAlertsRepository
            )

        // MARK: Change Password Use Case

        self.changePasswordUseCase =
            ChangePasswordUseCase(
                repository:
                    changePasswordRepository
            )

        // MARK: Alert Definitions Use Case

        self.getAlertDefinitionsUseCase =
            GetAlertDefinitionsUseCase(
                alertDefinitionRepository:
                    alertDefinitionRepository
            )

        // MARK: Save Mapped User

        self.saveMappedUserUseCase =
            SaveMappedUserUseCase(
                repository:
                    forwardAlertsRepository
            )

        // MARK: Delete Forward Alert User

        self.deleteForwardAlertUserUseCase =
            DeleteForwardAlertUserUseCase(
                repository:
                    forwardAlertsRepository
            )

        // MARK: Search Repository

        let searchLocalDataSource =
            UserDefaultsSearchDataSource()

        self.searchRepository =
            SearchRepositoryImpl(
                localDataSource:
                    searchLocalDataSource
            )

        // MARK: Login Use Case

        self.loginUseCase =
            LoginUseCase(
                authRepository:
                    authRepository,

                userRepository:
                    userRepository,

                searchRepository:
                    searchRepository
            )

        // MARK: Logout Use Case

        self.logoutUseCase =
            LogoutUseCase(
                userRepository:
                    userRepository
            )

        // MARK: Saved User Use Case

        self.getSavedUserUseCase =
            GetSavedUserUseCase(
                userRepository:
                    userRepository
            )

        // MARK: Alerts Use Case

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

        // MARK: Applications Use Case

        self.getApplicationsUseCase =
            GetApplicationsUseCase(
                applicationRepository:
                    applicationRepository
            )

        // MARK: Search Application Use Cases

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

        // MARK: Search Date Use Cases

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

        // MARK: Archived

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

        // MARK: Subscriptions

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

    // MARK: - View Models

   
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            loginUseCase: loginUseCase
            //,
            //analyticsTracker: analyticsTracker
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

    // MARK: Logout

    func makeLogoutUseCase()
        -> LogoutUseCase {

        return logoutUseCase
    }

    // MARK: Temporary Application Test

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
