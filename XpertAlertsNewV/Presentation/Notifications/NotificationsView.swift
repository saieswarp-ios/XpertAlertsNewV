import SwiftUI

struct NotificationsView: View {

    var body: some View {

        List {

            // today

            Section("Today") {

                NotificationRow(
                    title: "Critical Alert",
                    message:
                        "Database connection failed.",
                    time: "10:42 AM",
                    icon:
                        "exclamationmark.triangle.fill",
                    isUnread: true
                )

                NotificationRow(
                    title: "High CPU Usage",
                    message:
                        "CPU usage exceeded the configured threshold.",
                    time: "9:18 AM",
                    icon: "cpu.fill",
                    isUnread: true
                )
            }

            // yesterday

            Section("Yesterday") {

                NotificationRow(
                    title: "Backup Completed",
                    message:
                        "Daily backup completed successfully.",
                    time: "Yesterday",
                    icon:
                        "checkmark.circle.fill",
                    isUnread: false
                )

                NotificationRow(
                    title: "Alert Forwarded",
                    message:
                        "The selected alert was forwarded successfully.",
                    time: "Yesterday",
                    icon:
                        "arrowshape.turn.up.right.fill",
                    isUnread: false
                )
            }

            // older

            Section("Older") {

                NotificationRow(
                    title: "System Update",
                    message:
                        "A new system update is available.",
                    time: "Sep 5",
                    icon:
                        "arrow.down.circle.fill",
                    isUnread: false
                )
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItem(
                placement: .topBarTrailing
            ) {

                Button("Read All") {
                    print("Read All tapped")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
            }
        }
    }
}


// notification row

struct NotificationRow: View {

    let title: String
    let message: String
    let time: String
    let icon: String
    let isUnread: Bool

    var body: some View {

        HStack(
            alignment: .top,
            spacing: 14
        ) {

            // Icon

            ZStack {

                Circle()
                    .fill(
                        Color(.secondarySystemBackground)
                    )
                    .frame(
                        width: 44,
                        height: 44
                    )

                Image(systemName: icon)
                    .font(.headline)
            }

            // Content

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                HStack(
                    alignment: .top,
                    spacing: 8
                ) {

                    Text(title)
                        .font(.headline)

                    if isUnread {

                        Circle()
                            .frame(
                                width: 8,
                                height: 8
                            )
                    }

                    Spacer()

                    Text(time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
    }
}
