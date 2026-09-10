import Foundation
final class DIContainer {
    let apiClient: APIClient
    let authRepository: AuthRepository
    let loginUseCase: LoginUseCase
    let userRepository: UserRepository
    let logoutUseCase: LogoutUseCase
    let getSavedUserUseCase: GetSavedUserUseCase
    let alertRepository: AlertRepository
    let getAlertsUseCase: GetAlertsUseCase
    
    init() {
        
        
      
        
     
        self.apiClient = URLSessionAPIClient()
        
        self.authRepository = AuthRepositoryImpl(
            
            apiClient: apiClient
        )
        
        
        let userLocalDataSource = UserDefaultsDataSource()
        
        self.userRepository = UserRepositoryImpl(localDataSource: userLocalDataSource)
        
        
        
        
        self.loginUseCase = LoginUseCase(
            
            
            authRepository: authRepository,
            userRepository: userRepository
        )
        self.logoutUseCase = LogoutUseCase(
      userRepository: userRepository
        )
        
        self.getSavedUserUseCase = GetSavedUserUseCase(
            userRepository: userRepository
        )
        self.alertRepository = AlertRepositoryImpl(
            
            apiClient: apiClient, userReportory: userRepository
        )
        
        self.getAlertsUseCase = GetAlertsUseCase(
            alertRepository: alertRepository
            
        )
        
    }
 func makeLoginViewModel() -> LoginViewModel {
            
     
     return LoginViewModel(
        loginUseCase: loginUseCase)
    }
    
    func makeAlertsViewModel() -> AlertsViewModel {
        return AlertsViewModel(
            getAlertsUseCase: getAlertsUseCase)
        
    }
  
              
}



