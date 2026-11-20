
import SwiftUI

struct SubscriptionsSearchView: View {

    @ObservedObject var viewModel: SubscriptionsViewModel

    @Environment(\.dismiss) private var dismiss

    let applications: [Application]

    @Binding var selectedApplicationId: Int?

    let isLoadingApplications: Bool
    let applicationError: String?

    let onSearch: () -> Void
    let onReset: () -> Void

    private var activeStatusBinding: Binding<Int> {
        Binding(
            get: { viewModel.searchActive },
            set: { viewModel.searchActive = $0 }
        )
    }

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Header

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

//                Image(systemName: "magnifyingglass")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundStyle(Color.white)
//                    .frame(width: 40, height: 40)
//                    .background(Color.themeOrange.opacity(1))
//                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text("Search Subscriptions")
                    .font(.avenirBold(size: 21))
                    .foregroundStyle(Color.themeOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 4)

                // Reset Button - Top Right

                Button {
                    onReset()
                    dismiss()
                } label: {
                    Text("Reset")
                        .font(.avenirDemiBold(size: 14))
                        .foregroundStyle(Color.themeOrange)
                        .frame(height: 40)
                        .padding(.horizontal, 12)
                        .background(Color.themeOrange.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.themeOrange.opacity(0.5),
                                    lineWidth: 1
                                )
                        }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // MARK: - Search Filters

            VStack(alignment: .leading, spacing: 16) {

                // Application

                VStack(alignment: .leading, spacing: 5) {

                    Text("Application")
                        .font(.avenirMedium(size: 13))
                        .foregroundStyle(.secondary)

                    Picker(
                        "Application",
                        selection: $selectedApplicationId
                    ) {

                        Text("All Applications")
                            .tag(Int?.none)

                        ForEach(applications) { application in
                            Text(application.name)
                                .tag(Optional(application.id))
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Color.themeOrange)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .frame(height: 44)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                // Alert Name

                VStack(alignment: .leading, spacing: 5) {

                    Text("Alert Name")
                        .font(.avenirMedium(size: 13))
                        .foregroundStyle(.secondary)

                    HStack(spacing: 8) {

                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)

                        TextField(
                            "Enter alert name",
                            text: $viewModel.searchName
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.search)
                        .onSubmit {
                            onSearch()
                            dismiss()
                        }

                        if !viewModel.searchName.isEmpty {

                            Button {
                                viewModel.searchName = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Clear alert name")
                        }
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                // Active Status

                VStack(alignment: .leading, spacing: 5) {

                    Text("Active Status")
                        .font(.avenirMedium(size: 13))
                        .foregroundStyle(.secondary)

                    Picker(
                        "Active Status",
                        selection: activeStatusBinding
                    ) {
                        Text("Yes").tag(1)
                        Text("No").tag(0)
                        Text("All").tag(2)
                    }
                    .pickerStyle(.segmented)
                }

                // Application Error

                if isLoadingApplications {
                    ProgressView("Loading applications...")
                }

                if let applicationError {
                    Text(applicationError)
                        .font(.avenirRegular(size: 12))
                        .foregroundStyle(.red)
                }

                // MARK: - Full Width Search Button

                Button {
                    onSearch()
                    dismiss()
                } label: {
                    Label(
                        "Search",
                        systemImage: "magnifyingglass"
                    )
                    .font(.avenirDemiBold(size: 15))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundStyle(.white)
                    .background(Color.themeOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isLoading || isLoadingApplications)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
    }
}

