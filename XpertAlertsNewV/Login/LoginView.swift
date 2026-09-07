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
            
            }
        
        .padding()
        .onChange(of: viewModel.loginSucceeded) { _, succeeded in
            
            if succeeded {
                cooardinator.showAlerts()
                
            }
            
        }
        
    }
    
}


