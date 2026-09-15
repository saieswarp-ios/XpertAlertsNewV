import SwiftUI

struct AlertCardView: View {

    let title: String
    let message: String
    let application: String
    let date: String
    let severity: String

    private var severityColor: Color {

        switch severity.lowercased() {

        case "critical":
            return .themeRed

        case "warning":
            return .themeRed

        case "info":
            return .themeRed

        default:
            return .primary
        }
    }

    private var severityIcon: String {

        switch severity.lowercased() {

        case "critical":
            return "exclamationmark.triangle.fill"

        case "warning":
            return "exclamationmark.circle.fill"

        case "info":
            return "info.circle.fill"

        default:
            return "bell.fill"
        }
    }

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

          // top rowww

            HStack(
                alignment: .top,
                spacing: 12
            ) {

                Image(systemName: severityIcon)
                    .font(
                        .system(
                            size: 18,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.primary)     /////// chnages the caution markssss
                    .frame(
                        width: 40,
                        height: 40
                    )
                    .background(
                        .secondary.opacity(0.15),
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
                        .foregroundStyle(.primary)

                    Text(message)
                        .font(
                            .system(
                                size: 13,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(.secondary)
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )
                }

                Spacer(minLength: 4)
            }

            AppDivider()

         // information

            HStack(spacing: 14) {

                HStack(spacing: 6) {

                    Image(systemName: "square.grid.2x2.fill")
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

                    Image(systemName: "clock.fill")
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

          //severity

            AppStatusChip(
                title: severity,
                color: severityColor,
                icon: severityIcon
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

