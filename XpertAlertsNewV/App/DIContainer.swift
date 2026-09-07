import Foundation
final class DIContainer {
    
    let authRepository: AuthRepository
    let loginUseCase: LoginUseCase
    init() {
        self.authRepository = AuthRepositoryImpl()
        
        self.loginUseCase = LoginUseCase(
            
            
            authRepository: authRepository)
        
    }
 func makeLoginViewModel() -> LoginViewModel {
            
     
     return LoginViewModel(
        loginUseCase: loginUseCase)
    }
    
}



