
import SwiftUI

// MARK: - Screen Icon

struct AppScreenIcon: View {

    let systemName: String
    let color: Color

    @ScaledMetric(relativeTo: .body)
    private var iconSize: CGFloat = 20

    @ScaledMetric(relativeTo: .body)
    private var iconFrameSize: CGFloat = 42

    var body: some View {

        Image(systemName: systemName)
            .font(
                .system(
                    size: iconSize,
                    weight: .semibold
                )
            )
            .foregroundStyle(color)
            .frame(
                width: iconFrameSize,
                height: iconFrameSize
            )
            .background(
                color.opacity(0.12),
                in: RoundedRectangle(
                    cornerRadius: 12
                )
            )
    }
}


// MARK: - Screen Header

struct AppScreenHeader: View {

    let title: String
    let subtitle: String?
    let icon: String
    let iconColor: Color
    let titleColor: Color

    @ScaledMetric(relativeTo: .title2)
    private var titleSize: CGFloat = 23

    @ScaledMetric(relativeTo: .body)
    private var subtitleSize: CGFloat = 13

    init(
        title: String,
        subtitle: String? = nil,
        icon: String,
        iconColor: Color = .themeOrange,
        titleColor: Color = .themeOrange
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.titleColor = titleColor
    }

    var body: some View {

        HStack(
            alignment: .center,
            spacing: 14
        ) {

            AppScreenIcon(
                systemName: icon,
                color: iconColor
            )

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(title)
                    .font(.avenirBold(size: titleSize))
                    .foregroundStyle(titleColor)

                if let subtitle {

                    Text(subtitle)
                        .font(.avenirRegular(size: subtitleSize))
                        .foregroundStyle(.secondary)
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )
                }
            }

            Spacer(minLength: 0)
        }
    }
}


// MARK: - Section Title

struct SectionTitle: View {

    let title: String
    let subtitle: String?
    let icon: String?

    @ScaledMetric(relativeTo: .body)
    private var iconSize: CGFloat = 20

    @ScaledMetric(relativeTo: .body)
    private var iconFrameSize: CGFloat = 40

    @ScaledMetric(relativeTo: .headline)
    private var titleSize: CGFloat = 18

    @ScaledMetric(relativeTo: .body)
    private var subtitleSize: CGFloat = 13

    init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }

    var body: some View {

        HStack(
            alignment: .center,
            spacing: 12
        ) {

            if let icon {

                Image(systemName: icon)
                    .font(
                        .system(
                            size: iconSize,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(Color.themeBlue)
                    .frame(
                        width: iconFrameSize,
                        height: iconFrameSize
                    )
                    .background(
                        Color.themeOrange.opacity(0.12),
                        in: RoundedRectangle(
                            cornerRadius: 11
                        )
                    )
            }

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(title)
                    .font(.avenirBold(size: titleSize))
                    .foregroundStyle(.primary)

                if let subtitle {

                    Text(subtitle)
                        .font(.avenirRegular(size: subtitleSize))
                        .foregroundStyle(.secondary)
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )
                }
            }

            Spacer(minLength: 0)
        }
    }
}


// MARK: - App Card

struct AppCard<Content: View>: View {

    let content: Content

    @ScaledMetric(relativeTo: .body)
    private var cardPadding: CGFloat = 16

    @ScaledMetric(relativeTo: .body)
    private var cornerRadius: CGFloat = 18

    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {

        content
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(cardPadding)
            .background(
                Color(.secondarySystemBackground),
                in: RoundedRectangle(
                    cornerRadius: cornerRadius
                )
            )
    }
}


// MARK: - App Background

struct AppBackground: View {

    var body: some View {

        Color(.systemGroupedBackground)
            .ignoresSafeArea()
    }
}


// MARK: - Status Chip

struct AppStatusChip: View {

    let title: String
    let color: Color
    let icon: String

    @ScaledMetric(relativeTo: .body)
    private var iconSize: CGFloat = 12

    @ScaledMetric(relativeTo: .body)
    private var horizontalPadding: CGFloat = 10

    @ScaledMetric(relativeTo: .body)
    private var verticalPadding: CGFloat = 6

    var body: some View {

        HStack(spacing: 6) {

            Image(systemName: icon)

            Text(title)
                .font(.avenirDemiBold(size: iconSize))
        }
        .foregroundStyle(color)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(
            color.opacity(0.12),
            in: Capsule()
        )
    }
}


// MARK: - App Divider

struct AppDivider: View {

    @ScaledMetric(relativeTo: .body)
    private var dividerSpacing: CGFloat = 2

    var body: some View {

        Divider()
            .padding(.vertical, dividerSpacing)
    }
}

