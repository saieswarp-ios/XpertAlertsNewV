//
//  LoginView.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel: LoginViewModel
    
    let cooardinator: AppCoordinator
    
    init(container: DIContainer,
    coordinator: AppCoordinator) {
        
        self.cooardinator = coordinator
           
           _viewModel = StateObject(
            wrappedValue: container.makeLoginViewModel()
           )
       }
    
    var body: some View {
        VStack{
            Text("XpertAlerts")
                .font(.largeTitle)
                
            Text("Login")
                .foregroundColor(.purple
                )
            
            TextField("Email", text: $viewModel.email)
            
            SecureField("Password", text: $viewModel.password)
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                
            }
            
            Button("Login"){
                
                viewModel.login()
            }
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
            
            }
        
        .padding()
        .onReceive(viewModel.$loginResult){  result in

            guard let result else {
                return
            }
            switch result {
                
            case .success:
                cooardinator.showAlerts()
                
            case .passwordExpired:
                cooardinator.showChangePassword()
                
                
            }
                
            }
            
        }
        
    
    
}


