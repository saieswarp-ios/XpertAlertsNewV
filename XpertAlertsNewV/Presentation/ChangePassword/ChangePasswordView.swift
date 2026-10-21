import SwiftUI
import Combine

struct ChangePasswordView: View {

    @StateObject private var viewModel: ChangePasswordViewModel

    let container: DIContainer
    @Environment(\.dismiss) private var dismiss
    init(container: DIContainer) {
        self.container = container

        _viewModel = StateObject(
            wrappedValue: ChangePasswordViewModel(
                changePasswordUseCase: container.changePasswordUseCase,
                userRepository: container.userRepository
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
        
            // MARK: - Header

            HStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.themeOrange)
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
               

                AppScreenHeader(
                    title: "Change Password",
                    subtitle: nil,
                    icon: "lock.fill"
                )

                Spacer(minLength: 0)
            }
            .padding()
        

            // MARK: - Password Form

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)

                        Text("Enter your current password and choose a new one.")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 0) {

                        PasswordInputRow(
                            title: "Current Password",
                            text: $viewModel.currentPassword
                        )

                        Divider()
                            .padding(.leading, 16)

                        PasswordInputRow(
                            title: "New Password",
                            text: $viewModel.newPassword
                        )

                        Divider()
                            .padding(.leading, 16)

                        PasswordInputRow(
                            title: "Confirm Password",
                            text: $viewModel.confirmPassword
                        )
                    }
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                Color.gray.opacity(0.15),
                                lineWidth: 1
                            )
                    }

                    // MARK: - Result Message

                    if let message = viewModel.message {
                        HStack(alignment: .top, spacing: 10) {
                            Image(
                                systemName: viewModel.isSuccess
                                    ? "checkmark.circle.fill"
                                    : "exclamationmark.circle.fill"
                            )

                            Text(message)
                                .font(.system(size: 14))
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )
                        }
                        .foregroundStyle(
                            viewModel.isSuccess ? .green : .red
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(
                            (viewModel.isSuccess ? Color.green : Color.red)
                                .opacity(0.08)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // MARK: - Update Button

                    Button {
                        viewModel.updatePassword()
                    } label: {
                        HStack(spacing: 10) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "lock.rotation")
                                Text("Update Password")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .foregroundStyle(.white)
                        .background(Color.themeOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(viewModel.isLoading)
                    .opacity(viewModel.isLoading ? 0.7 : 1.0)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Password Input Row

private struct PasswordInputRow: View {

    let title: String
    @Binding var text: String

    @State private var isPasswordVisible = false

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: "lock")
                .foregroundStyle(.secondary)
                .frame(width: 20)

            Group {
                if isPasswordVisible {
                    TextField(title, text: $text)
                } else {
                    SecureField(title, text: $text)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textContentType(.none)

            Button {
                isPasswordVisible.toggle()
            } label: {
                Image(
                    systemName: isPasswordVisible
                        ? "eye.slash"
                        : "eye"
                )
                .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                isPasswordVisible ? "Hide password" : "Show password"
            )
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 54)
    }
}
