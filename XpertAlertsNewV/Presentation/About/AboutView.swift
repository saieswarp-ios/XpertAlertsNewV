import SwiftUI

struct AboutView: View {

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                //header

                VStack(spacing: 12) {

                    ZStack {

                        RoundedRectangle(
                            cornerRadius: 24
                        )
                        .fill(
                            Color(.secondarySystemBackground)
                        )
                        .frame(
                            width: 110,
                            height: 110
                        )

                        Image(
                            systemName: "bell.badge.fill"
                        )
                        .font(.system(size: 48))
                    }

                    Text("XpertAlerts")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(
                        "Stay informed. Respond faster."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)

                // about

                AboutSection(
                    title: "About XpertAlerts"
                ) {

                    Text(
                        "XpertAlerts helps you monitor, manage, and respond to important alerts from your applications and services."
                    )
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                }

                // features

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    Text("Features")
                        .font(.title2)
                        .fontWeight(.bold)

                    AboutFeatureRow(
                        icon: "bell.fill",
                        title: "Alert Monitoring",
                        description:
                            "Stay informed about important events."
                    )

                    Divider()

                    AboutFeatureRow(
                        icon: "magnifyingglass",
                        title: "Smart Search",
                        description:
                            "Find alerts quickly using filters."
                    )

                    Divider()

                    AboutFeatureRow(
                        icon:
                            "arrowshape.turn.up.right.fill",
                        title: "Alert Forwarding",
                        description:
                            "Share important alerts with others."
                    )

                    Divider()

                    AboutFeatureRow(
                        icon: "archivebox.fill",
                        title: "Alert History",
                        description:
                            "Keep track of previous alerts."
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            Color(.secondarySystemBackground)
                        )
                )

                // links

                VStack(spacing: 0) {

                    AboutLinkButton(
                        title: "Privacy Policy",
                        icon: "hand.raised.fill"
                    ) {
                        print("Privacy Policy tapped")
                    }

                    Divider()

                    AboutLinkButton(
                        title: "Terms & Conditions",
                        icon: "doc.text.fill"
                    ) {
                        print("Terms tapped")
                    }

                    Divider()

                    AboutLinkButton(
                        title: "Contact Support",
                        icon: "questionmark.circle.fill"
                    ) {
                        print("Contact Support tapped")
                    }
                }
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            Color(.secondarySystemBackground)
                        )
                )

                // footer
                VStack(spacing: 6) {

                    Text("XpertAlerts")
                        .font(.headline)

                    Text("© 2026 XpertAlerts")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 16)
            }
            .padding()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// about

struct AboutSection<Content: View>: View {

    let title: String
    let content: Content

    init(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            content
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color(.secondarySystemBackground)
                )
        )
    }
}


//feature

struct AboutFeatureRow: View {

    let icon: String
    let title: String
    let description: String

    var body: some View {

        HStack(
            alignment: .top,
            spacing: 14
        ) {

            Image(systemName: icon)
                .font(.title3)
                .frame(
                    width: 40,
                    height: 40
                )

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }

            Spacer()
        }
    }
}


//link button

struct AboutLinkButton: View {

    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 14) {

                Image(systemName: icon)
                    .frame(width: 28)

                Text(title)

                Spacer()

                Image(
                    systemName: "chevron.right"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 15)
        }
        .buttonStyle(.plain)
    }
}
