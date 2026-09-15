import SwiftUI

struct SubscriptionsView: View {

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                // Header

                VStack(alignment: .leading, spacing: 6) {

                    Text("Subscription")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(
                        "Manage your XpertAlerts subscription."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                // Current Plan

                VStack(alignment: .leading, spacing: 16) {

                    HStack {

                        VStack(
                            alignment: .leading,
                            spacing: 5
                        ) {

                            Text("CURRENT PLAN")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)

                            Text("Professional")
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        Spacer()

                        Image(
                            systemName: "checkmark.seal.fill"
                        )
                        .font(.system(size: 32))
                    }

                    Divider()

                    HStack(spacing: 10) {

                        Image(systemName: "checkmark.circle.fill")

                        Text("Your subscription is active.")
                            .font(.subheadline)
                    }

                    HStack(spacing: 10) {

                        Image(systemName: "calendar")

                        Text("Renews on September 30")
                            .font(.subheadline)
                    }
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            Color(.secondarySystemBackground)
                        )
                )

                //  - Available Plans

                Text("Available Plans")
                    .font(.title2)
                    .fontWeight(.bold)

                SubscriptionPlanCard(
                    name: "Basic",
                    price: "$9.99",
                    description: "For small teams",
                    features: [
                        "Alert monitoring",
                        "Basic notifications",
                        "7-day alert history"
                    ]
                )

                SubscriptionPlanCard(
                    name: "Professional",
                    price: "$19.99",
                    description: "For growing teams",
                    features: [
                        "Unlimited alerts",
                        "Advanced notifications",
                        "30-day alert history",
                        "Alert forwarding"
                    ],
                    isCurrent: true
                )

                SubscriptionPlanCard(
                    name: "Enterprise",
                    price: "$49.99",
                    description: "For larger organizations",
                    features: [
                        "Everything in Professional",
                        "Advanced reporting",
                        "Priority support",
                        "Extended alert history"
                    ]
                )

                // Information

                Text(
                    "Subscription changes will take effect according to your current billing period."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
            }
            .padding()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Subscriptions")
        .navigationBarTitleDisplayMode(.inline)
    }
}


//  Subscription Plan Card

struct SubscriptionPlanCard: View {

    let name: String
    let price: String
    let description: String
    let features: [String]
    var isCurrent: Bool = false

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 18
        ) {

            // Plan Header

            HStack {

                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {

                    HStack(spacing: 8) {

                        Text(name)
                            .font(.title2)
                            .fontWeight(.bold)

                        if isCurrent {

                            Text("CURRENT")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(
                                    .horizontal,
                                    8
                                )
                                .padding(
                                    .vertical,
                                    4
                                )
                                .background(
                                    Capsule()
                                        .fill(
                                            Color(
                                                .tertiarySystemBackground
                                            )
                                        )
                                )
                        }
                    }

                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(
                    alignment: .trailing,
                    spacing: 2
                ) {

                    Text(price)
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("/ month")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            // Features

            VStack(
                alignment: .leading,
                spacing: 11
            ) {

                ForEach(
                    features,
                    id: \.self
                ) { feature in

                    HStack(spacing: 10) {

                        Image(
                            systemName:
                                "checkmark.circle.fill"
                        )

                        Text(feature)
                            .font(.subheadline)
                    }
                }
            }

            // Action

            if isCurrent {

                Text("Current Plan")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                        .fill(
                            Color(
                                .tertiarySystemBackground
                            )
                        )
                    )

            } else {

                Button {

                    print(
                        "Select \(name) plan"
                    )

                } label: {

                    Text("Choose \(name)")
                        .fontWeight(.semibold)
                        .frame(
                            maxWidth: .infinity
                        )
                }
                .buttonStyle(
                    .borderedProminent
                )
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
