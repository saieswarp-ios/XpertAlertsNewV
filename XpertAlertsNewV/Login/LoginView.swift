import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @State private var visible = false
    let coordinator: AppCoordinator

    init(container: DIContainer, coordinator: AppCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: container.makeLoginViewModel())
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 22) {
                    HStack {
                        Spacer()
                        
                        Button {
                            coordinator.showBuildSettings()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(Color.themeGreen)
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                        
                        
                        
//                        Button {
//                        } label: {
//                            Image(systemName: "gearshape.fill")
//                                .font(.title3)
//                                .foregroundStyle(Color.themeGreen)
//                                .frame(width: 44, height: 44)
//                                .background(.regularMaterial, in: Circle())
//                        }
                    }

                    VStack(spacing: 8) {
                        Image("XpertAlerts")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 280, maxHeight: 120)

                        Text("Secure business alert management")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 4)

                    AppCard {
                        VStack(spacing: 16) {
                            SectionTitle(
                                title: "Sign in",
                                subtitle: "Use your XpertAlerts account credentials.",
                                icon: "person.crop.circle"
                            )

                            loginField("person.fill", "User ID / Email", text: $viewModel.email, secure: false)

                            loginField("lock.fill", "Password", text: $viewModel.password, secure: !visible) {
                                visible.toggle()
                            }

                            PrimaryButton(
                                title: viewModel.isLoading ? "Signing in…" : "Login",
                                systemImage: "arrow.right.circle.fill"
                            ) {
                                Task {
                                    viewModel.login()
                                }
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }

                    HStack(spacing: 8) {
                        Image(systemName: UserDefaults.standard.bool(forKey: "BaseURLVerified") ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                            .foregroundStyle(UserDefaults.standard.bool(forKey: "BaseURLVerified") ? Color.themeGreen : Color.themeOrange)

                        Text(UserDefaults.standard.bool(forKey: "BaseURLVerified") ? "Server verified for this session." : "Test the server connection in Settings before login.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Text("App Version · v1.0")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
            }
        }
        .navigationBarHidden(true)
        .alert("Authentication Failed", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred.")
        }
        .onReceive(viewModel.$loginResult) { result in
            guard let result else { return }
            switch result {
            case .success:
                coordinator.showAlerts()
            case .passwordExpired:
                coordinator.showChangePassword()
            }
        }
    }

    @ViewBuilder
    private func loginField(
        _ icon: String,
        _ title: String,
        text: Binding<String>,
        secure: Bool,
        action: (() -> Void)? = nil
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.themeGreen)
                .frame(width: 20)

            if secure {
                SecureField(title, text: text)
            } else {
                TextField(title, text: text)
            }

            if let action {
                Button(action: action) {
                    Image(systemName: visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .padding(14)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: 14)
        )
    }
}
