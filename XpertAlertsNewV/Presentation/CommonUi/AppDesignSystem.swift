import SwiftUI

// screen icon

struct AppScreenIcon: View {

    let systemName: String
    let color: Color

    var body: some View {

        Image(systemName: systemName)
            .font(
                .system(
                    size: 20,
                    weight: .semibold
                )
            )
            .foregroundStyle(color)
            .frame(
                width: 42,
                height: 42
            )
            .background(
                color.opacity(0.12),
                in: RoundedRectangle(
                    cornerRadius: 12
                )
            )
    }
}


// screen header

struct AppScreenHeader: View {

    let title: String
    let subtitle: String?
    let icon: String
    let iconColor: Color
    let titleColor: Color

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
                    .font(
                        .system(
                            size: 23,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(titleColor)

                if let subtitle {

                    Text(subtitle)
                        .font(
                            .system(
                                size: 13,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
    }
}


// section title

struct SectionTitle: View {

    let title: String
    let subtitle: String?
    let icon: String?
   

    init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
      
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
                            size: 20,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        Color.themeBlue     // sign in side icon color
                    )
                    .frame(
                        width: 40,
                        height: 40
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
                    .font(
                        .system(
                            size: 18,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.primary)

                if let subtitle {

                    Text(subtitle)
                        .font(
                            .system(
                                size: 13,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
    }
}


// app card

struct AppCard<Content: View>: View {

    let content: Content

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
            .padding(16)
            .background(
                Color(.secondarySystemBackground),
                in: RoundedRectangle(
                    cornerRadius: 18
                )
            )
    }
}


//app background

struct AppBackground: View {

    var body: some View {

        Color(.systemGroupedBackground)
            .ignoresSafeArea()
    }
}


// status chip

struct AppStatusChip: View {

    let title: String
    let color: Color
    let icon: String

    var body: some View {

        HStack(spacing: 6) {

            Image(systemName: icon)

            Text(title)
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            color.opacity(0.12),
            in: Capsule()
        )
    }
}


// app divider

struct AppDivider: View {

    var body: some View {

        Divider()
            .padding(.vertical, 2)
    }
}

