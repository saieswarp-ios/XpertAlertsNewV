//import SwiftUI
//
//struct MoreView: View {
//
//    let coordinator: AppCoordinator
//    let logoutUseCase: LogoutUseCase
//    let container: DIContainer
//
//    @State private var showLogoutConfirmation = false
//
//    var body: some View {
//
//        NavigationStack {
//
//            List {
//
//                // MARK: - Account
//
//                Section("Account") {
//
//                    NavigationLink {
//                        SubscriptionsView(
//                            container: container
//                        )
//                    } label: {
//                        MoreRow(
//                            icon: "creditcard.fill",
//                            title: "Subscriptions",
//                            subtitle: "Manage your subscription",
//                            iconColor: .teal
//                        )
//                    }
//
//                    NavigationLink {
//                        ChangePasswordView(
//                            container: container
//                        )
//                    } label: {
//                        MoreRow(
//                            icon: "lock.fill",
//                            title: "Change Password",
//                            subtitle: "Update your account password",
//                            iconColor: .indigo
//                        )
//                    }
//                }
//
//                // MARK: - Information
//
//                Section("Information") {
//
//                    NavigationLink {
//                        AboutView()
//                    } label: {
//                        MoreRow(
//                            icon: "info.circle.fill",
//                            title: "About XpertAlerts",
//                            subtitle: "App information and details",
//                            iconColor: .yellow
//                        )
//                    }
//                }
//
//                // MARK: - Logout
//
//                Section {
//
//                    Button {
//                        showLogoutConfirmation = true
//                    } label: {
//
//                        HStack(spacing: 14) {
//
//                            Image(
//                                systemName: "rectangle.portrait.and.arrow.right"
//                            )
//                            .frame(width: 28)
//
//                            Text("Logout")
//                               // .fontWeight(.semibold)
//                                .font(.avenirDemiBold(size: 18))
//
//                            Spacer()
//                        }
//                    }
//                    .foregroundStyle(.red)
//                    .padding(.vertical, 6)
//
//                }
//            }
//            .navigationTitle("More")
//            .navigationBarTitleDisplayMode(.large)
//            
//            .alert(
//                "Confirm Logout",
//                isPresented: $showLogoutConfirmation
//            ) {
//                Button("Cancel", role: .cancel) {
//                    showLogoutConfirmation = false
//                }
//
//                Button("OK", role: .destructive) {
//                    logoutUseCase.execute()
//                    coordinator.route = .login
//                }
//            } message: {
//                Text("Are you sure you want to logout?")
//            }
//           
//        }
//    }
//}
//
//
//
////more view 
//// MARK: - More Row
//
//struct MoreRow: View {
//
//    let icon: String
//    let title: String
//    let subtitle: String
//    var iconColor: Color = .primary
//
//    var body: some View {
//
//        HStack(spacing: 14) {
//
//            Image(systemName: icon)
//             //   .font(.title3)
//            
//                .font(.avenirDemiBold(size: 20))
//                .foregroundStyle(iconColor)
//                .frame(width: 38, height: 38)
//
//            VStack(
//                alignment: .leading,
//                spacing: 3
//            ) {
//
//                Text(title)
////                    .font(.body)
////                    .fontWeight(.medium)
//                    .font(.avenirMedium(size: 17))
//
//                Text(subtitle)
//                   // .font(.caption)
//                
//                    .font(.avenirRegular(size: 12))
//                    .foregroundStyle(.secondary)
//            }
//
//            Spacer()
//        }
//        .padding(.vertical, 4)
//    }
//}
//


import SwiftUI

struct MoreView: View {

    let coordinator: AppCoordinator
    let logoutUseCase: LogoutUseCase
    let container: DIContainer

    @State private var showLogoutConfirmation = false

    var body: some View {

        NavigationStack {

            List {

                // MARK: - Account

                Section("Account") {

                    // Archived

                    NavigationLink {

                        ArchivedView(
                            container: container,
                            coordinator: coordinator
                        )

                    } label: {

                        MoreRow(
                            icon: "archivebox.fill",
                            title: "Archived",
                            subtitle: "View archived alerts",
                            iconColor: .orange
                        )
                    }

                    // Change Password

                    NavigationLink {

                        ChangePasswordView(
                            container: container
                        )

                    } label: {

                        MoreRow(
                            icon: "lock.fill",
                            title: "Change Password",
                            subtitle: "Update your account password",
                            iconColor: .indigo
                        )
                    }
                }

                // MARK: - Information

                Section("Information") {

                    NavigationLink {

                        AboutView()

                    } label: {

                        MoreRow(
                            icon: "info.circle.fill",
                            title: "About XpertAlerts",
                            subtitle: "App information and details",
                            iconColor: .yellow
                        )
                    }
                }

                // MARK: - Logout

                Section {

                    Button {

                        showLogoutConfirmation = true

                    } label: {

                        HStack(spacing: 14) {

                            Image(
                                systemName: "rectangle.portrait.and.arrow.right"
                            )
                            .frame(width: 28)

                            Text("Logout")
                                .font(.avenirDemiBold(size: 18))

                            Spacer()
                        }
                    }
                    .foregroundStyle(.red)
                    .padding(.vertical, 6)

                }
            }

            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)

            // MARK: - Logout Confirmation

            .alert(
                "Confirm Logout",
                isPresented: $showLogoutConfirmation
            ) {

                Button("Cancel", role: .cancel) {

                    showLogoutConfirmation = false
                }

                Button("OK", role: .destructive) {

                    logoutUseCase.execute()
                    coordinator.route = .login
                }

            } message: {

                Text("Are you sure you want to logout?")
            }
        }
    }
}

// MARK: - More Row

struct MoreRow: View {

    let icon: String
    let title: String
    let subtitle: String

    var iconColor: Color = .primary

    var body: some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.avenirDemiBold(size: 20))
                .foregroundStyle(iconColor)
                .frame(width: 38, height: 38)

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(title)
                    .font(.avenirMedium(size: 17))

                Text(subtitle)
                    .font(.avenirRegular(size: 12))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
