
import SwiftUI

struct SubscriptionDetailView: View {

    let subscription: Subscription
    @ObservedObject var viewModel: SubscriptionsViewModel
    let container: DIContainer

    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: - Subscription Information

                VStack(alignment: .leading, spacing: 0) {

                    Text("Subscription Information")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .padding(.bottom, 12)

                    DetailRow(
                        title: "Subscription ID",
                        value: String(subscription.id)
                    )

                    DetailRow(
                        title: "Alert Name",
                        value: subscription.alertName ?? "-"
                    )

                    DetailRow(
                        title: "Alert Definition",
                        value: subscription.alertDefinitionName ?? "-"
                    )

                    DetailRow(
                        title: "Application",
                        value: subscription.applicationName ?? "-"
                    )

                    DetailRow(
                        title: "Email",
                        value: subscription.email ?? "-"
                    )

                    DetailRow(
                        title: "Device",
                        value: subscription.device ?? "-"
                    )

                    DetailRow(
                        title: "Status",
                        value: subscription.active == 1
                            ? "Active"
                            : "Inactive"
                    )
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: - Subscription Details

                VStack(alignment: .leading, spacing: 0) {

                    Text("Subscription Details")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .padding(.bottom, 12)

                    if viewModel.isLoadingDetails {

                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(.vertical, 30)

                    } else if let details =
                                viewModel.selectedSubscriptionDetails,
                              details.userSubId == subscription.id {

                        DetailRow(
                            title: "Subscription ID",
                            value: String(details.userSubId ?? 0)
                        )

                        DetailRow(
                            title: "Alert Name",
                            value: details.alertName ?? "-"
                        )

                        DetailRow(
                            title: "Alert Definition ID",
                            value: String(details.alertDefId ?? 0)
                        )

                        DetailRow(
                            title: "Application ID",
                            value: String(details.applicationId ?? 0)
                        )

                        DetailRow(
                            title: "User ID",
                            value: String(details.userId ?? 0)
                        )

                        DetailRow(
                            title: "Alert Type ID",
                            value: details.alertTypeId ?? "-"
                        )

                        DetailRow(
                            title: "Alert Flag",
                            value: String(details.alertFlag ?? 0)
                        )

                        DetailRow(
                            title: "Subject",
                            value: details.subject ?? "-"
                        )

                        DetailRow(
                            title: "Threshold",
                            value: String(details.threshold ?? 0)
                        )

                        DetailRow(
                            title: "Sort Order",
                            value: String(details.sortOrder ?? 0)
                        )

                        DetailRow(
                            title: "Status",
                            value: details.active == 1
                                ? "Active"
                                : "Inactive"
                        )

                    } else {

                        Text("No subscription details available.")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 10)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 30)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Subscription Details")
        .navigationBarTitleDisplayMode(.inline)

        // MARK: - Edit Button

        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CreateSubscriptionView(
                        getApplicationsUseCase:
                            container.getApplicationsUseCase,
                        getAlertDefinitionsUseCase:
                            container.getAlertDefinitionsUseCase,
                        userRepository:
                            container.userRepository,
                        saveSubscriptionUseCase:
                            container.saveSubscriptionUseCase,
                        getDuplicateSubscriptionUseCase:
                            container.getDuplicateSubscriptionUseCase,
                        subscriptionToEdit: subscription,
                        getSubscriptionDetailsUseCase:
                            container.getSubscriptionDetailsUseCase,
                        onSaveSuccess: {
                            viewModel.loadSubscriptions()
                            viewModel.loadSubscriptionDetails(
                                subscriptionId: subscription.id
                            )
                        }
                    )
                } label: {
                    Image(systemName: "pencil")
                        .foregroundStyle(Color.themeOrange)
                }
                .accessibilityLabel("Edit Subscription")
            }
        }

        // MARK: - Load Details

        .task {
            viewModel.loadSubscriptionDetails(
                subscriptionId: subscription.id
            )
        }
    }
}

// MARK: - Detail Row

private struct DetailRow: View {

    let title: String
    let value: String

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body)
                .foregroundStyle(.primary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 9)

        Divider()
    }
}

