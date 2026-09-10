//
//  ChangePasswordView.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 08/09/26.
//

import SwiftUI

struct ChangePasswordView: View {
    var body: some View {
        
        VStack(spacing: 20) {

            Text("Change Password")
                .font(.largeTitle)

            Text("Your password has expired.")

            Text("Please change your password to continue.")
        }
        .padding()
    }
}

#Preview {
    ChangePasswordView()
}
