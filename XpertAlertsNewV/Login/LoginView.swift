//
//  LoginView.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 07/09/26.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel: LoginViewModel
    
    init(container: DIContainer) {
           
           _viewModel = StateObject(
               wrappedValue: container.makeLoginViewModel()
           )
       }
    
    var body: some View {
        VStack{
            Text("XpertAlerts")
                .font(.largeTitle)
                
            Text("Login")
            
            TextField("Email", text: $viewModel.email)
            
            SecureField("Password", text: $viewModel.password)
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                
            }
            
            Button("Login"){
                
print("Login Tapped")
                viewModel.login()
            }
            
            }
        
        .padding()
        
    }
    
}


