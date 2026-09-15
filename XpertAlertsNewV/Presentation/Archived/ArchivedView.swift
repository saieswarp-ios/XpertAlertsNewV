import SwiftUI

struct ArchivedView: View {

  
    
    
    private let archivedAlerts = [
        (
            "Poc Isuue solved",
            "The POC issue was resolved successfully.",
            "Client side",
            "Yesterday",
            "Info"
        ),
        (
            "screen refresh",
            "solved",
            "dispatch",
            "2 days ago",
            "Info"
        ),
        (
            "Patch deliver",
            "done good",
            "Production",
            "3 days ago",
            "Warning"
        )
    ]

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                // header

                AppScreenHeader(
                    title: "Archived",
                    subtitle: "Review your previously archived alerts",
                    icon: "archivebox.fill",
                    iconColor: .themeBlue,
                    titleColor: .themeBlue
                )

          // overview

//                AppCard {
//
//                    HStack(spacing: 14) {
//
//                        Image(systemName: "archivebox.fill")
//                            .font(
//                                .system(
//                                    size: 20,
//                                    weight: .semibold
//                                )
//                            )
//                            .foregroundStyle(
//                                Color.themeBlue
//                            )
//                            .frame(
//                                width: 44,
//                                height: 44
//                            )
//                            .background(
//                                Color.themeBlue.opacity(0.12),
//                                in: RoundedRectangle(
//                                    cornerRadius: 12
//                                )
//                            )
//
//                        VStack(
//                            alignment: .leading,
//                            spacing: 4
//                        ) {
//
//                            Text("Archived Alerts")
//                                .font(
//                                    .system(
//                                        size: 17,
//                                        weight: .bold
//                                    )
//                                )
//
//                            Text(
//                                "\(archivedAlerts.count) alerts are currently archived."
//                            )
//                            .font(
//                                .system(
//                                    size: 13
//                                )
//                            )
//                            .foregroundStyle(.secondary)
//                        }
//
//                        Spacer()
//                    }
//                }

                // section

                SectionTitle(
                    title: "Archived History",
                    subtitle: "Previously handled alerts",
                    icon: "clock.arrow.circlepath"
                    
                )

                // archived list

                VStack(spacing: 14) {

                    ForEach(
                        archivedAlerts.indices,
                        id: \.self
                    ) { index in

                        let alert = archivedAlerts[index]

                        ArchivedAlertCard(
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
            .padding(.bottom, 30)
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
    }
}


//archived alert card

struct ArchivedAlertCard: View {

    let title: String
    let message: String
    let application: String
    let date: String
    let severity: String

    private var severityColor: Color {

        switch severity.lowercased() {

        case "warning":
            return .primary

        case "info":
            return .primary

        default:
            return .primary
        }
    }

    private var severityIcon: String {

        switch severity.lowercased() {

        case "warning":
            return "exclamationmark.circle.fill"

        case "info":
            return "info.circle.fill"

        default:
            return "archivebox.fill"
        }
    }

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            // title row

            HStack(
                alignment: .top,
                spacing: 12
            ) {

                Image(systemName: severityIcon)
                    .font(
                        .system(
                            size: 17,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(severityColor)
                    .frame(
                        width: 40,
                        height: 40
                    )
                    .background(
                        severityColor.opacity(0.12),
                        in: RoundedRectangle(
                            cornerRadius: 11
                        )
                    )

                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {

                    Text(title)
                        .font(
                            .system(
                                size: 16,
                                weight: .bold
                            )
                        )

                    Text(message)
                        .font(
                            .system(
                                size: 13
                            )
                        )
                        .foregroundStyle(.secondary)
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )
                }

                Spacer()
            }

            AppDivider()

            //Details

            HStack {

                HStack(spacing: 6) {

                    Image(
                        systemName: "square.grid.2x2.fill"
                    )
                    .font(.system(size: 11))

                    Text(application)
                        .font(
                            .system(
                                size: 12,
                                weight: .medium
                            )
                        )
                }
                .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 6) {

                    Image(
                        systemName: "clock.fill"
                    )
                    .font(.system(size: 11))

                    Text(date)
                        .font(
                            .system(
                                size: 12,
                                weight: .medium
                            )
                        )
                }
                .foregroundStyle(.secondary)
            }

            // status

            AppStatusChip(
                title: "Archived",
                color: .themeBlue,
                icon: "archivebox.fill"
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(16)
        .background(
            Color(.secondarySystemBackground),
            in: RoundedRectangle(
                cornerRadius: 18
            )
        )
    }
}
