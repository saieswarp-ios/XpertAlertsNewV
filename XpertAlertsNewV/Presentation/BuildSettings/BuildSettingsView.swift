//
//import SwiftUI
//
//struct BuildSettingsView: View {
//
//    @State private var baseURL = ""
//    @State private var isTesting = false
//    @State private var testPassed = false
//    @State private var showSaveConfirmation = false
//
//    private let themeOrange = Color(
//        red: 0.95,
//        green: 0.36,
//        blue: 0.06
//    )
//
//    var body: some View {
//
//        VStack(spacing: 0) {
//
//            //header
//
//            HStack {
//
//                Image(systemName: "gearshape.fill")
//                    .font(.system(size: 20, weight: .semibold))
//                    .foregroundStyle(.white)
//                    .frame(width: 42, height: 42)
//                    .background(
//                        Circle()
//                            .fill(.white.opacity(0.18))
//                    )
//
//                VStack(
//                    alignment: .leading,
//                    spacing: 2
//                ) {
//
//                    Text("Build Settings")
//                        .font(
//                            .system(
//                                size: 18,
//                                weight: .bold
//                            )
//                        )
//                        .foregroundStyle(.white)
//
//                    Text("Server Configuration")
//                        .font(.system(size: 11))
//                        .foregroundStyle(.white.opacity(0.8))
//                }
//
//                Spacer()
//
//                Button {
//
//                    if testPassed {
//                        showSaveConfirmation = true
//                    }
//
//                } label: {
//
//                    Image(
//                        systemName:
//                            "square.and.arrow.down.fill"
//                    )
//                    .font(
//                        .system(
//                            size: 20,
//                            weight: .semibold
//                        )
//                    )
//                    .foregroundStyle(.white)
//                }
//                .disabled(!testPassed)
//                .opacity(testPassed ? 1 : 0.45)
//            }
//            .padding(.horizontal, 16)
//            .frame(height: 72)
//            .background(themeOrange)
//
//            // content
//
//            ScrollView {
//
//                VStack(
//                    alignment: .leading,
//                    spacing: 24
//                ) {
//
//                    //configuaration
//
//                    VStack(
//                        alignment: .leading,
//                        spacing: 6
//                    ) {
//
//                        Text("SERVER CONFIGURATION")
//                            .font(
//                                .system(
//                                    size: 12,
//                                    weight: .bold
//                                )
//                            )
//                            .foregroundStyle(themeOrange)
//
//                        Text("Connection Settings")
//                            .font(
//                                .system(
//                                    size: 22,
//                                    weight: .bold
//                                )
//                            )
//
//                        Text(
//                            "Configure the server address used by XpertAlerts."
//                        )
//                        .font(.system(size: 14))
//                        .foregroundStyle(.secondary)
//                    }
//
//                    // url card
//
//                    VStack(
//                        alignment: .leading,
//                        spacing: 12
//                    ) {
//
//                        HStack(spacing: 10) {
//
//                            Image(systemName: "link")
//                                .foregroundStyle(themeOrange)
//
//                            Text("Base URL")
//                                .font(
//                                    .system(
//                                        size: 16,
//                                        weight: .semibold
//                                    )
//                                )
//                        }
//
//                        Text(
//                            "Enter the URL provided by your administrator."
//                        )
//                        .font(.system(size: 13))
//                        .foregroundStyle(.secondary)
//
//                        TextField(
//                            "https://example.com",
//                            text: $baseURL
//                        )
//                        .font(.system(size: 15))
//                        .textInputAutocapitalization(.never)
//                        .autocorrectionDisabled()
//                        .keyboardType(.URL)
//                        .padding(.horizontal, 14)
//                        .frame(height: 50)
//                        .background(
//                            RoundedRectangle(
//                                cornerRadius: 12
//                            )
//                            .fill(
//                                Color(.systemBackground)
//                            )
//                        )
//                        .overlay(
//                            RoundedRectangle(
//                                cornerRadius: 12
//                            )
//                            .stroke(
//                                Color.gray.opacity(0.25),
//                                lineWidth: 1
//                            )
//                        )
//                    }
//                    .padding(16)
//                    .background(
//                        RoundedRectangle(
//                            cornerRadius: 18
//                        )
//                        .fill(
//                            Color(.secondarySystemBackground)
//                        )
//                    )
//
//                    // test connection
//
//                    VStack(
//                        alignment: .leading,
//                        spacing: 12
//                    ) {
//
//                        Text("Connection Test")
//                            .font(
//                                .system(
//                                    size: 17,
//                                    weight: .bold
//                                )
//                            )
//
//                        Text(
//                            "Test the server connection before saving the URL."
//                        )
//                        .font(.system(size: 13))
//                        .foregroundStyle(.secondary)
//
//                        Button {
//
//                            testConnection()
//
//                        } label: {
//
//                            HStack {
//
//                                if isTesting {
//
//                                    ProgressView()
//                                        .tint(.white)
//
//                                } else {
//
//                                    Image(
//                                        systemName:
//                                            "bolt.horizontal.circle.fill"
//                                    )
//                                }
//
//                                Text(
//                                    isTesting
//                                    ? "Testing Connection..."
//                                    : "Test Connection"
//                                )
//                                .font(
//                                    .system(
//                                        size: 16,
//                                        weight: .semibold
//                                    )
//                                )
//                            }
//                            .frame(
//                                maxWidth: .infinity
//                            )
//                            .frame(height: 50)
//                        }
//                        .foregroundStyle(.white)
//                        .background(
//                            RoundedRectangle(
//                                cornerRadius: 13
//                            )
//                            .fill(themeOrange)
//                        )
//                        .disabled(
//                            baseURL
//                                .trimmingCharacters(
//                                    in: .whitespacesAndNewlines
//                                )
//                                .isEmpty ||
//                            isTesting
//                        )
//                    }
//
//                    // ststus
//
//                    VStack(
//                        alignment: .leading,
//                        spacing: 12
//                    ) {
//
//                        Text("Connection Status")
//                            .font(
//                                .system(
//                                    size: 17,
//                                    weight: .bold
//                                )
//                            )
//
//                        HStack(spacing: 12) {
//
//                            Image(
//                                systemName:
//                                    testPassed
//                                    ? "checkmark.circle.fill"
//                                    : "questionmark.circle.fill"
//                            )
//                            .font(.title2)
//                            .foregroundStyle(
//                                testPassed
//                                ? .green
//                                : themeOrange
//                            )
//
//                            VStack(
//                                alignment: .leading,
//                                spacing: 3
//                            ) {
//
//                                Text(
//                                    testPassed
//                                    ? "Connection Successful"
//                                    : "Connection Not Tested"
//                                )
//                                .font(
//                                    .system(
//                                        size: 15,
//                                        weight: .semibold
//                                    )
//                                )
//
//                                Text(
//                                    testPassed
//                                    ? "The server is reachable."
//                                    : "Test the connection before saving."
//                                )
//                                .font(.system(size: 13))
//                                .foregroundStyle(.secondary)
//                            }
//
//                            Spacer()
//                        }
//                        .padding()
//                        .background(
//                            RoundedRectangle(
//                                cornerRadius: 14
//                            )
//                            .fill(
//                                Color(.secondarySystemBackground)
//                            )
//                        )
//                    }
//
//                    // MARK: Save Information
//
//                    HStack(
//                        alignment: .top,
//                        spacing: 10
//                    ) {
//
//                        Image(
//                            systemName: "info.circle.fill"
//                        )
//                        .foregroundStyle(themeOrange)
//
//                        Text(
//                            "The URL must be tested successfully before it can be saved."
//                        )
//                        .font(.system(size: 13))
//                        .foregroundStyle(.secondary)
//                    }
//                    .padding(.horizontal, 4)
//                }
//                .padding(16)
//            }
//        }
//        .background(
//            Color(.systemGroupedBackground)
//                .ignoresSafeArea()
//        )
//        .navigationBarBackButtonHidden(false)
//        .alert(
//            "Save Base URL?",
//            isPresented: $showSaveConfirmation
//        ) {
//
//            Button("Cancel", role: .cancel) {}
//
//            Button("Save") {
//                saveURL()
//            }
//
//        } message: {
//
//            Text(
//                "Are you sure you want to save this server URL?"
//            )
//        }
//    }
//
//    //test connection
//
//    private func testConnection() {
//
//        isTesting = true
//        testPassed = false
//
//        // Temporary UI behavior.
//        // Real API connection will be connected later.
//
//        DispatchQueue.main.asyncAfter(
//            deadline: .now() + 1
//        ) {
//
//            isTesting = false
//            testPassed = true
//        }
//    }
//
//    // save
//
//    private func saveURL() {
//
//        let url = baseURL
//            .trimmingCharacters(
//                in: .whitespacesAndNewlines
//            )
//
//        UserDefaults.standard.set(
//            url,
//            forKey: "BaseURL"
//        )
//
//        UserDefaults.standard.set(
//            true,
//            forKey: "BaseURLVerified"
//        )
//
//        print("Saved Base URL:", url)
//    }
//}
import SwiftUI

struct BuildSettingsView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var baseURL = ""
    @State private var isTesting = false
    @State private var testPassed = false
    @State private var showSaveConfirmation = false

    var body: some View {

        VStack(spacing: 0) {

            // Header

            HStack(spacing: 12) {

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 38, height: 38)
                        .background(
                            Color.white.opacity(0.15)
                        )
                        .clipShape(Circle())
                }

                VStack(
                    alignment: .leading,
                    spacing: 2
                ) {

                    Text("Build Settings")
                        .font(
                            .system(
                                size: 21,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)

                    Text("Server Configuration")
                        .font(.system(size: 12))
                        .foregroundStyle(
                            Color.white.opacity(0.8)
                        )
                }

                Spacer()
            }
            .padding(.horizontal, 18)
            .frame(height: 68)
            .background(Color.themeOrange)


            // Content

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {

                    //Server URL

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
                                .foregroundStyle(
                                    Color.themeOrange
                                )

                            Text("Server URL")
                                .font(
                                    .system(
                                        size: 17,
                                        weight: .bold
                                    )
                                )
                        }

                        Text(
                            "Enter the Web Service URL provided by your administrator."
                        )
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                        TextField(
                            "https://example.com",
                            text: $baseURL
                        )
                        .font(.system(size: 15))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                        .padding(.horizontal, 15)
                        .frame(height: 52)
                        .background(
                            Color(.systemGray6)
                        )
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 14
                            )
                            .stroke(
                                Color.themeOrange.opacity(0.25),
                                lineWidth: 1
                            )
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 14
                            )
                        )
                    }
                    .padding(18)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                    )
                    .shadow(
                        color: .black.opacity(0.06),
                        radius: 10,
                        y: 4
                    )


                    //  Connection Status

                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {

                        Text("Connection Status")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .bold
                                )
                            )

                        HStack(spacing: 12) {

                            Image(
                                systemName:
                                    testPassed
                                    ? "checkmark.circle.fill"
                                    : "questionmark.circle.fill"
                            )
                            .font(.system(size: 25))
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
                                .font(
                                    .system(
                                        size: 15,
                                        weight: .semibold
                                    )
                                )

                                Text(
                                    testPassed
                                    ? "The server is reachable."
                                    : "Test the connection before saving."
                                )
                                .font(.system(size: 13))
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
                        RoundedRectangle(
                            cornerRadius: 18
                        )
                        .stroke(
                            testPassed
                            ? Color.themeGreen.opacity(0.20)
                            : Color.themeOrange.opacity(0.15),
                            lineWidth: 1
                        )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 18
                        )
                    )


                    //  Buttons

                    HStack(spacing: 12) {

                        // TEST BUTTON

                        Button {
                            testConnection()
                        } label: {

                            HStack(spacing: 7) {

                                if isTesting {

                                    ProgressView()
                                        .tint(.white)

                                } else {

                                    Image(
                                        systemName:
                                            "bolt.horizontal.fill"
                                    )
                                }

                                Text(
                                    isTesting
                                    ? "Testing..."
                                    : "Test Connection"
                                )
                            }
                            .font(
                                .system(
                                    size: 14,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.white)
                            .frame(
                                maxWidth: .infinity
                            )
                            .frame(height: 50)
                            .background(
                                Color.themeGreen
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 14
                                )
                            )
                        }
                        .disabled(
                            baseURL
                                .trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                )
                                .isEmpty || isTesting
                        )


                        // SAVE BUTTON

                        Button {

                            if testPassed {
                                showSaveConfirmation = true
                            }

                        } label: {

                            HStack(spacing: 7) {

                                Text("Save")

                                Image(
                                    systemName:
                                        "arrow.right"
                                )
                            }
                            .font(
                                .system(
                                    size: 14,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.white)
                            .frame(
                                maxWidth: .infinity
                            )
                            .frame(height: 50)
                            .background(
                                testPassed
                                ? Color.themeOrange
                                : Color.gray.opacity(0.5)
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 14
                                )
                            )
                        }
                        .disabled(!testPassed)
                    }
                }
                .padding(20)
            }
        }
        .background(
            Color(.systemGroupedBackground)
        )
        .navigationBarBackButtonHidden(true)


        //  Save Confirmation

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


    //  Test Connection

    private func testConnection() {

        isTesting = true
        testPassed = false

        // Temporary UI behavior.
        // Real API will be connected later.

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1
        ) {

            isTesting = false
            testPassed = true
        }
    }


    // Save URL

    private func saveURL() {

        let url = baseURL.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        UserDefaults.standard.set(
            url,
            forKey: "BaseURL"
        )

        UserDefaults.standard.set(
            true,
            forKey: "BaseURLVerified"
        )

        print("Saved Base URL:", url)
    }
}
