import SwiftUI

struct ChangePasswordView: View {

    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                // header

                VStack(spacing: 12) {

                    ZStack {

                        Circle()
                            .fill(
                                Color(.secondarySystemBackground)
                            )
                            .frame(
                                width: 90,
                                height: 90
                            )

                        Image(
                            systemName: "lock.shield.fill"
                        )
                        .font(.system(size: 40))
                    }

                    Text("Change Password")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(
                        "Update your password to keep your account secure."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)

                // password fields

                VStack(
                    alignment: .leading,
                    spacing: 18
                ) {

                    PasswordInputField(
                        title: "Current Password",
                        placeholder: "Enter current password",
                        text: $currentPassword
                    )

                    PasswordInputField(
                        title: "New Password",
                        placeholder: "Enter new password",
                        text: $newPassword
                    )

                    PasswordInputField(
                        title: "Confirm New Password",
                        placeholder: "Confirm new password",
                        text: $confirmPassword
                    )
                }

                //requirements

                VStack(
                    alignment: .leading,
                    spacing: 14
                ) {

                    Text("Password Requirements")
                        .font(.headline)

                    PasswordRequirement(
                        text: "At least 8 characters"
                    )

                    PasswordRequirement(
                        text: "Contains an uppercase letter"
                    )

                    PasswordRequirement(
                        text: "Contains a lowercase letter"
                    )

                    PasswordRequirement(
                        text: "Contains a number"
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            Color(.secondarySystemBackground)
                        )
                )

                // update button

                Button {

                    print("Update Password tapped")

                } label: {

                    HStack {

                        Image(
                            systemName: "checkmark"
                        )

                        Text("Update Password")
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                // security message

                HStack(
                    alignment: .top,
                    spacing: 10
                ) {

                    Image(
                        systemName: "info.circle.fill"
                    )

                    Text(
                        "After changing your password, you may need to sign in again."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.bottom, 10)
            }
            .padding()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// pass input filed

struct PasswordInputField: View {

    let title: String
    let placeholder: String

    @Binding var text: String

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)

            SecureField(
                placeholder,
                text: $text
            )
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        Color(.secondarySystemBackground)
                    )
            )
        }
    }
}


//pass required

struct PasswordRequirement: View {

    let text: String

    var body: some View {

        HStack(spacing: 10) {

            Image(
                systemName: "checkmark.circle"
            )

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
