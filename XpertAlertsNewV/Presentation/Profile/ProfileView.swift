import SwiftUI

struct ProfileView: View {

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                //profile header

                VStack(spacing: 12) {

                    ZStack {

                        Circle()
                            .fill(
                                Color.primary
                            )
                            .frame(
                                width: 110,
                                height: 110
                            )

                        Image(
                            systemName:
                                "person.fill"
                        )
                        .font(.system(size: 50))
                    }

                    Text("John Doe")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("XpertAlerts User")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)

                // account information

                ProfileSection(
                    title: "Account Information"
                ) {

                    ProfileRow(
                        icon: "person.fill",
                        title: "Username",
                        value: "john.doe"
                    )

                    Divider()

                    ProfileRow(
                        icon: "person.text.rectangle.fill",
                        title: "First Name",
                        value: "John"
                    )

                    Divider()

                    ProfileRow(
                        icon: "person.text.rectangle.fill",
                        title: "Last Name",
                        value: "Doe"
                    )
                }

                // application

                ProfileSection(
                    title: "Application"
                ) {

                    ProfileRow(
                        icon: "app.fill",
                        title: "Application",
                        value: "XpertAlerts"
                    )

                    Divider()

                    ProfileRow(
                        icon: "checkmark.circle.fill",
                        title: "Status",
                        value: "Active"
                    )
                }

                // account actions

                VStack(spacing: 0) {

                    Button {
                        print("Edit Profile tapped")
                    } label: {

                        HStack(spacing: 14) {

                            Image(
                                systemName:
                                    "pencil.circle.fill"
                            )
                            .font(.title3)

                            Text("Edit Profile")
                                .fontWeight(.medium)

                            Spacer()

                            Image(
                                systemName:
                                    "chevron.right"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding()
                    }

                    Divider()

                    Button {
                        print("Account Settings tapped")
                    } label: {

                        HStack(spacing: 14) {

                            Image(
                                systemName:
                                    "gearshape.fill"
                            )
                            .font(.title3)

                            Text("Account Settings")
                                .fontWeight(.medium)

                            Spacer()

                            Image(
                                systemName:
                                    "chevron.right"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding()
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            Color(.secondarySystemBackground)
                        )
                )
            }
            .padding()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// profile section

struct ProfileSection<Content: View>: View {

    let title: String
    let content: Content

    init(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            Text(title)
                .font(.headline)

            VStack(spacing: 14) {
                content
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color(.secondarySystemBackground)
                )
        )
    }
}


// profile row

struct ProfileRow: View {

    let icon: String
    let title: String
    let value: String

    var body: some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.subheadline)
                .frame(
                    width: 30,
                    height: 30
                )

            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
    }
}
