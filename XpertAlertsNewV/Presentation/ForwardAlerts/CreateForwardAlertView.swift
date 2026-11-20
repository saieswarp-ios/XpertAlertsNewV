
import SwiftUI

struct CreateForwardAlertView: View {

    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: CreateForwardAlertViewModel

    @State private var sortOrder = "1"
    @State private var isActive = true

    init(viewModel: CreateForwardAlertViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {

        VStack(spacing: 0) {

            // Custom Header

            HStack(spacing: 12) {

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.themeOrange)
                        .frame(width: 28, height: 40)
                }
                .buttonStyle(.plain)

                Text("Create Forward Alert")
                    .font(.avenirBold(size: 21))
                    .foregroundStyle(Color.themeOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // Form Content

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                 //Application

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Application")
                            .font(.avenirDemiBold(size: 17))

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

                   // Users

                    VStack(alignment: .leading, spacing: 8) {

                        Text("User")
                            .font(.avenirDemiBold(size: 17))

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

                   //Selected User Email

                    if viewModel.selectedUser != nil {

                        VStack(alignment: .leading, spacing: 8) {

                            Text("Email")
                                .font(.avenirDemiBold(size: 17))

                            if viewModel.isLoadingEmail {

                                ProgressView("Loading Email...")

                            } else {

                                TextField(
                                    "Enter email address",
                                    text: $viewModel.selectedEmail
                                )
                                .font(.avenirRegular(size: 16))
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }

                            if let errorMessage = viewModel.errorMessage,
                               !errorMessage.isEmpty {

                                Text(errorMessage)
                                    .font(.avenirRegular(size: 12))
                                    .foregroundStyle(.red)
                                    .fixedSize(
                                        horizontal: false,
                                        vertical: true
                                    )
                            }
                        }
                    }

                   //Sort Order

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Sort Order")
                            .font(.avenirDemiBold(size: 17))

                        TextField("Enter sort order", text: $sortOrder)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                            )
                    }

                    //Status

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Status")
                            .font(.avenirDemiBold(size: 17))

                        Picker("Status", selection: $isActive) {

                            Text("Active").tag(true)
                            Text("Inactive").tag(false)
                        }
                        .pickerStyle(.segmented)
                    }

                    // Save Result

                    if let saveMessage = viewModel.saveMessage,
                       !saveMessage.isEmpty {

                        Text(saveMessage)
                            .font(.avenirRegular(size: 15))
                            .foregroundStyle(.green)
                    }

                    // Error Message

                    if let errorMessage = viewModel.errorMessage,
                       !errorMessage.isEmpty,
                       viewModel.selectedUser == nil {

                        Text(errorMessage)
                            .font(.avenirRegular(size: 12))
                            .foregroundStyle(.red)
                    }

                    // Save Button

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
                        .font(.avenirDemiBold(size: 16))
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
                        Int(sortOrder) == nil ||
                        (Int(sortOrder) ?? -1) < 0
                    )

                    Spacer(minLength: 20)
                }
                .padding()
            }
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadApplications()
        }
    }
}

