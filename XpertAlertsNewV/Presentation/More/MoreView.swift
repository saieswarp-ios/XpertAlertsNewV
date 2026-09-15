import SwiftUI

struct MoreView: View {

    var body: some View {

        NavigationStack {

            List {

                //profile

                Section {

                    NavigationLink {
                        ProfileView()
                    } label: {

                        HStack(spacing: 14) {

                            Image(
                                systemName:
                                    "person.circle.fill"
                            )
                            .foregroundStyle(Color.themeRed)
                            .font(.system(size: 46))

                            VStack(
                                alignment: .leading,
                                spacing: 4
                            ) {

                                Text("My Profile")
                                    .font(.headline)

                                Text(
                                    "Manage your account"
                                )
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }

                // alerts

                Section("Alerts") {

                    NavigationLink {
                        ForwardAlertsView()
                    } label: {

                        MoreRow(
                          
                            icon: "arrowshape.turn.up.right.fill",
                            title: "Forward Alerts",
                            subtitle:
                                "Share alerts with others",
                            iconColor: .brown,
                        
                        )
                       
                    }
                    

                    NavigationLink {
                        NotificationsView()
                    } label: {

                        MoreRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle:
                                "Manage your notifications",
                            iconColor: .cyan
                        )
                    }
                }

                // account

                Section("Account") {

                    NavigationLink {
                        SubscriptionsView()
                    } label: {

                        MoreRow(
                            icon: "creditcard.fill",
                            title: "Subscriptions",
                            subtitle:
                                "Manage your subscription",
                            iconColor: .teal
                        )
                    }

                    NavigationLink {
                        ChangePasswordView()
                    } label: {

                        MoreRow(
                            icon: "lock.fill",
                            title: "Change Password",
                            subtitle:
                                "Update your account password"
                            , iconColor: .indigo
                        )
                    }
                }

                // information

                Section("Information") {

                    NavigationLink {
                        AboutView()
                    } label: {

                        MoreRow(
                            icon: "info.circle.fill",
                            title: "About XpertAlerts",
                            subtitle:
                                "App information and details",
                            iconColor: .yellow
                        )
                    }
                }

                // logout

                Section {

                    Button {

                        print("Logout tapped")

                    } label: {

                        HStack(spacing: 14) {

                            Image(
                                systemName:
                                    "rectangle.portrait.and.arrow.right"
                            )
                            .frame(width: 28)

                            Text("Logout")
                                .fontWeight(.semibold)

                            Spacer()
                        }
                    }
                    .foregroundStyle(.red)
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


// more

struct MoreRow: View {

    let icon: String
    let title: String
    let subtitle: String
    var iconColor: Color = .primary

    var body: some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(iconColor)
                .frame(
                    width: 38,
                    height: 38
                )

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

