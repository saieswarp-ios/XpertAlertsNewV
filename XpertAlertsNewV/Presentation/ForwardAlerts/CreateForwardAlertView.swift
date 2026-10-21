
import SwiftUI

struct CreateForwardAlertView: View {

    @StateObject private var viewModel: CreateForwardAlertViewModel

    @State private var sortOrder = "1"
    @State private var isActive = true

    init(viewModel: CreateForwardAlertViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Create Forward Alert")
                    .font(.title2)
                    .fontWeight(.semibold)

                // MARK: - Application

                VStack(alignment: .leading, spacing: 8) {
                    Text("Application")
                        .font(.headline)

                    if viewModel.isLoading {
                        ProgressView("Loading Applications...")
                    } else if viewModel.applications.isEmpty {
                        Text("No applications found")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.applications) { application in
                            Button {
                                Task {
                                    await viewModel.selectApplication(application)
                                }
                            } label: {
                                HStack {
                                    Text(application.name)
                                    Spacer()

                                    Image(
                                        systemName:
                                            viewModel.selectedApplication?.id == application.id
                                            ? "checkmark"
                                            : "chevron.right"
                                    )
                                    .foregroundStyle(
                                        viewModel.selectedApplication?.id == application.id
                                        ? Color.themeOrange
                                        : Color.secondary
                                    )
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // MARK: - Users

                VStack(alignment: .leading, spacing: 8) {
                    Text("User")
                        .font(.headline)

                    if viewModel.isLoadingUsers {
                        ProgressView("Loading Users...")
                    } else if viewModel.users.isEmpty {
                        Text("No users found")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.users) { user in
                            Button {
                                viewModel.selectUser(user)
                            } label: {
                                HStack {
                                    Text(user.userName)
                                    Spacer()

                                    Image(
                                        systemName:
                                            viewModel.selectedUser?.id == user.id
                                            ? "checkmark"
                                            : "chevron.right"
                                    )
                                    .foregroundStyle(
                                        viewModel.selectedUser?.id == user.id
                                        ? Color.themeOrange
                                        : Color.secondary
                                    )
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // MARK: - Selected User Email

                if viewModel.selectedUser != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.headline)

                        if viewModel.isLoadingEmail {
                            ProgressView("Loading Email...")
                        } else if !viewModel.selectedEmail.isEmpty {
                            Text(viewModel.selectedEmail)
                                .font(.body)
                                .foregroundStyle(.primary)
                                .textSelection(.enabled)
                        }

                        if let errorMessage = viewModel.errorMessage,
                           !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )
                        }
                    }
                }

                // MARK: - Sort Order

                VStack(alignment: .leading, spacing: 8) {
                    Text("Sort Order")
                        .font(.headline)

                    TextField("Enter sort order", text: $sortOrder)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                        )
                }

                // MARK: - Status

                VStack(alignment: .leading, spacing: 8) {
                    Text("Status")
                        .font(.headline)

                    Picker("Status", selection: $isActive) {
                        Text("Active").tag(true)
                        Text("Inactive").tag(false)
                    }
                    .pickerStyle(.segmented)
                }

                // MARK: - Save Result

                if let saveMessage = viewModel.saveMessage,
                   !saveMessage.isEmpty {
                    Text(saveMessage)
                        .font(.subheadline)
                        .foregroundStyle(.green)
                }

                // Show errors that aren't the missing-email message
                if let errorMessage = viewModel.errorMessage,
                   !errorMessage.isEmpty,
                   viewModel.selectedUser == nil {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                // MARK: - Save Button

                Button {
                    guard let order = Int(sortOrder),
                          order >= 0 else {
                        return
                    }

                    Task {
                        await viewModel.saveMappedUser(
                            sortOrder: order,
                            active: isActive ? 1 : 0
                        )
                    }
                } label: {
                    HStack {
                        if viewModel.isSaving {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "checkmark.circle")
                            Text("Save Forward Alert")
                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.themeOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(
                    viewModel.isSaving ||
                    viewModel.isLoadingEmail ||
                    viewModel.selectedApplication == nil ||
                    viewModel.selectedUser == nil ||
                    viewModel.selectedEmail.isEmpty ||
                    Int(sortOrder) == nil ||
                    (Int(sortOrder) ?? -1) < 0
                )

                Spacer(minLength: 20)
            }
            .padding()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Create Forward Alert")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadApplications()
        }
    }
}

