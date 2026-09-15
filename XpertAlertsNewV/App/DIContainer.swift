import Foundation

final class DIContainer {

    

    let apiClient: APIClient


  

    let authRepository: AuthRepository

    let userRepository: UserRepository

    let alertRepository: AlertRepository

    private let searchRepository: SearchRepository



    let loginUseCase: LoginUseCase

    let logoutUseCase: LogoutUseCase

    let getSavedUserUseCase: GetSavedUserUseCase


 

    let getAlertsUseCase: GetAlertsUseCase


 

    private let saveSearchApplicationUseCase:
        SaveSearchApplicationUseCase

    let getSearchApplicationUseCase:
        GetSearchApplicationUseCase

    private let saveSearchDatesUseCase:
        SaveSearchDatesUseCase

    let getSearchDatesUseCase:
        GetSearchDatesUseCase




    init() {

        self.apiClient =
            URLSessionAPIClient()


        let userLocalDataSource =
            UserDefaultsDataSource()


        self.userRepository =
            UserRepositoryImpl(
                localDataSource:
                    userLocalDataSource
            )

        self.authRepository =
            AuthRepositoryImpl(
                apiClient:
                    apiClient
            )


        self.alertRepository =
            AlertRepositoryImpl(
                apiClient:
                    apiClient,

                userRepository:
                    userRepository
            )

        let searchLocalDataSource =
            UserDefaultsSearchDataSource()

        self.searchRepository =
            SearchRepositoryImpl(
                localDataSource:
                    searchLocalDataSource
            )


        self.loginUseCase =
            LoginUseCase(
                authRepository:
                    authRepository,

                userRepository:
                    userRepository
            )


        self.logoutUseCase =
            LogoutUseCase(
                userRepository:
                    userRepository
            )


        self.getSavedUserUseCase =
            GetSavedUserUseCase(
                userRepository:
                    userRepository
            )


        self.getAlertsUseCase =
            GetAlertsUseCase(
                alertRepository:
                    alertRepository
            )


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
    }


    func makeLoginViewModel() -> LoginViewModel {

        return LoginViewModel(
            loginUseCase:
                loginUseCase
        )
    }


    func makeAlertsViewModel() -> AlertsViewModel {

        return AlertsViewModel(
            getAlertsUseCase:
                getAlertsUseCase,

            getSearchApplicationUseCase:
                getSearchApplicationUseCase
        )
    }

    func makeSearchViewModel() -> SearchViewModel {

        return SearchViewModel(

            saveSearchApplicationUseCase:
                saveSearchApplicationUseCase,

            getSearchApplicationUseCase:
                getSearchApplicationUseCase,

            saveSearchDatesUseCase:
                saveSearchDatesUseCase,

            getSearchDatesUseCase:
                getSearchDatesUseCase
        )
    }
}
