import SwiftUI

struct AlertsView: View {

    private let alerts = [
        (
            "POC Issue",
            "Unable to Load Screen",
            "Production",
            "10:42 AM",
            "Critical"
        ),
        (
            "XpertAlerts",
            "Storage is running low",
            "Monitor Api",
            "9:18 AM",
            "Warning"
        ),
        (
            "Speed",
            "Run Api",
            "DvL Connected",
            "Yesterday",
            "Info"
        )
    ]

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

             // screen header

                AppScreenHeader(
                    title: "Alerts",
                    subtitle: "Monitor your latest business alerts",
                    icon: "bell.fill",
                    iconColor: .themeRed,
                    titleColor: .themeRed
                )

              // greeting

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text("Good morning")
                        .font(
                            .system(
                                size: 14,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(.secondary)

                    Text("Stay informed.")
                        .font(
                            .system(
                                size: 28,
                                weight: .bold
                            )
                        )

                    Text(
                        "Here is a quick overview of your alerts."
                    )
                    .font(
                        .system(
                            size: 14
                        )
                    )
                    .foregroundStyle(.secondary)
                }

        // summary

                HStack(spacing: 12) {

                    AlertSummaryCard(
                        value: "12",
                        title: "Total",
                        icon: "bell.fill",
                        color: .themeOrange
                    )

                    AlertSummaryCard(
                        value: "3",
                        title: "Critical",
                        icon: "exclamationmark.triangle.fill",
                        color: .themeRed
                    )

                    AlertSummaryCard(
                        value: "5",
                        title: "Today",
                        icon: "calendar",
                        color: .themeGreen
                    )
                }

              // recent alertss

                HStack {

                    SectionTitle(
                        title: "Recent Alerts",
                        subtitle: "Your latest notifications"
                    )

                    Spacer()

                    Button {

                        print("View All tapped")

                    } label: {

                        HStack(spacing: 4) {

                            Text("View All")

                            Image(
                                systemName: "chevron.right"
                            )
                            .font(
                                .system(
                                    size: 11,
                                    weight: .bold
                                )
                            )
                        }
                        .font(
                            .system(
                                size: 13,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            Color.primary
                        )
                    }
                }

             // alert list

                VStack(spacing: 14) {

                    ForEach(
                        alerts.indices,
                        id: \.self
                    ) { index in

                        let alert = alerts[index]

                        AlertCardView(
                            title: alert.0,
                            message: alert.1,
                            application: alert.2,
                            date: alert.3,
                            severity: alert.4
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
    }
}


//summary card

struct AlertSummaryCard: View {

    let value: String
    let title: String
    let icon: String
    let color: Color

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            Image(systemName: icon)
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .foregroundStyle(color)
                .frame(
                    width: 34,
                    height: 34
                )
                .background(
                    color.opacity(0.12),
                    in: RoundedRectangle(
                        cornerRadius: 10
                    )
                )

            Text(value)
                .font(
                    .system(
                        size: 24,
                        weight: .bold
                    )
                )

            Text(title)
                .font(
                    .system(
                        size: 12,
                        weight: .medium
                    )
                )
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(14)
        .background(
            Color(.secondarySystemBackground),
            in: RoundedRectangle(
                cornerRadius: 18
            )
        )
    }
}
