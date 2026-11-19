
import SwiftUI

struct BuildSettingsView: View {

    let coordinator: AppCoordinator

    @State private var baseURL = UserDefaults.standard.string(
        forKey: "BaseURL"
    ) ?? ""

    @State private var isTesting = false
    @State private var testPassed = false
    @State private var showSaveConfirmation = false
    @State private var verifiedURL = ""

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Header

            HStack(spacing: 12) {

                Button {
                    coordinator.showLogin()
                } label: {

                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.themeOrange)
                        .frame(width: 28, height: 40)

                }
                .buttonStyle(.plain)

                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.themeOrange)
                    .frame(width: 40, height: 40)
                    .background(Color.themeOrange.opacity(0.10))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                Color.themeOrange.opacity(0.30),
                                lineWidth: 1
                            )
                    }

                VStack(
                    alignment: .leading,
                    spacing: 2
                ) {

                    Text("Build Settings")
                        .font(.avenirBold(size: 21))
                        .foregroundStyle(Color.themeOrange)

                    Text("Server Configuration")
                        .font(.avenirRegular(size: 12))
                        .foregroundStyle(.secondary)

                }

                Spacer()

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // MARK: - Content

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {

                    // Server URL

                    VStack(
                        alignment: .leading,
                        spacing: 14
                    ) {

                        HStack(spacing: 10) {

                            Image(systemName: "link.circle.fill")
                                .font(
                                    .system(
                                        size: 18,
                                        weight: .semibold
                                    )
                                )
                                .foregroundStyle(Color.themeOrange)

                            Text("Server URL")
                                .font(.avenirBold(size: 17))

                        }

                        Text(
                            "Enter the Web Service URL provided by your administrator."
                        )
                        .font(.avenirRegular(size: 13))
                        .foregroundStyle(.secondary)

                        TextField(
                            "https://example.com",
                            text: $baseURL
                        )
                        .font(.avenirRegular(size: 15))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                        .padding(.horizontal, 15)
                        .frame(height: 52)
                        .background(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    Color.themeOrange.opacity(0.25),
                                    lineWidth: 1
                                )
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )

                    }
                    .padding(18)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
                    .shadow(
                        color: .black.opacity(0.06),
                        radius: 10,
                        y: 4
                    )

                    // Connection Status

                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {

                        Text("Connection Status")
                            .font(.avenirBold(size: 16))

                        HStack(spacing: 12) {

                            Image(
                                systemName: testPassed
                                    ? "checkmark.circle.fill"
                                    : "questionmark.circle.fill"
                            )
                            .font(.avenirRegular(size: 25))
                            .foregroundStyle(
                                testPassed
                                    ? Color.themeGreen
                                    : Color.themeOrange
                            )

                            VStack(
                                alignment: .leading,
                                spacing: 3
                            ) {

                                Text(
                                    testPassed
                                        ? "Connection Successful"
                                        : "Connection Not Tested"
                                )
                                .font(.avenirDemiBold(size: 15))

                                Text(
                                    testPassed
                                        ? "The server is reachable."
                                        : "Test the connection before saving."
                                )
                                .font(.avenirRegular(size: 13))
                                .foregroundStyle(.secondary)

                            }

                            Spacer()

                        }

                    }
                    .padding(18)
                    .background(
                        testPassed
                            ? Color.themeGreen.opacity(0.08)
                            : Color.themeOrange.opacity(0.07)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                testPassed
                                    ? Color.themeGreen.opacity(0.20)
                                    : Color.themeOrange.opacity(0.15),
                                lineWidth: 1
                            )
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )

                    // Buttons

                    HStack(spacing: 12) {

                        // Test Connection Button

                        Button {

                            Task {
                                await testConnection()
                            }

                        } label: {

                            HStack(spacing: 7) {

                                if isTesting {

                                    ProgressView()
                                        .tint(.white)

                                } else {

                                    Image(
                                        systemName: "bolt.horizontal.fill"
                                    )

                                }

                                Text(
                                    isTesting
                                        ? "Testing..."
                                        : "Test Connection"
                                )

                            }
                            .font(.avenirBold(size: 14))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.themeGreen)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )

                        }
                        .disabled(
                            baseURL
                                .trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                )
                                .isEmpty || isTesting
                        )

                        // Save Button

                        Button {

                            if testPassed {
                                showSaveConfirmation = true
                            }

                        } label: {

                            HStack(spacing: 7) {

                                Text("Save")

                                Image(systemName: "arrow.right")

                            }
                            .font(.avenirBold(size: 14))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                testPassed
                                    ? Color.themeOrange
                                    : Color.gray.opacity(0.5)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )

                        }
                        .disabled(!testPassed)

                    }

                }
                .padding(20)

            }

        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)

        // MARK: - Save Confirmation

        .alert(
            "Save Base URL?",
            isPresented: $showSaveConfirmation
        ) {

            Button("Cancel", role: .cancel) {}

            Button("Save") {
                saveURL()
            }

        } message: {

            Text(
                "Are you sure you want to save this server URL?"
            )

        }

    }

    // MARK: - Test Connection

    private func testConnection() async {

        let urlString = baseURL.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard
            let url = URL(string: urlString),
            let scheme = url.scheme,
            ["http", "https"].contains(scheme),
            url.host != nil
        else {

            await MainActor.run {
                testPassed = false
            }

            return
        }

        await MainActor.run {
            isTesting = true
            testPassed = false
        }

        do {

            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"

            let (_, response) = try await URLSession.shared.data(
                for: request
            )

            guard let httpResponse = response as? HTTPURLResponse else {

                await MainActor.run {
                    isTesting = false
                    testPassed = false
                }

                return
            }

            await MainActor.run {

                isTesting = false

                testPassed = (200...499).contains(
                    httpResponse.statusCode
                )

                if testPassed {

                    let finalURL = urlString.hasSuffix("/")
                        ? urlString
                        : urlString + "/"

                    baseURL = finalURL

                    UserDefaults.standard.set(
                        finalURL,
                        forKey: "BaseURL"
                    )

                    UserDefaults.standard.set(
                        true,
                        forKey: "BaseURLVerified"
                    )

                }

            }

        } catch {

            print("Connection test failed:", error)

            await MainActor.run {
                isTesting = false
                testPassed = false
            }

        }

    }

    // MARK: - Save URL

    private func saveURL() {

        let url = baseURL.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let finalURL = url.hasSuffix("/")
            ? url
            : url + "/"

        // Save server URL

        UserDefaults.standard.set(
            finalURL,
            forKey: "BaseURL"
        )

        // Save successful verification

        UserDefaults.standard.set(
            true,
            forKey: "BaseURLVerified"
        )

        print("Saved Base URL:", finalURL)
        print("Server Verified:", true)

        coordinator.showLogin()

    }

}


