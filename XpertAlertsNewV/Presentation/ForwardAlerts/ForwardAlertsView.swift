import SwiftUI

struct ForwardAlertsView: View {

    @State private var recipientEmail = ""
    @State private var message = ""

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                // header

                VStack(alignment: .leading, spacing: 6) {

                    Text("Forward an Alert")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(
                        "Send an important alert to another recipient."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                //selected alert

                VStack(alignment: .leading, spacing: 12) {

                    Text("Selected Alert")
                        .font(.headline)

                    VStack(
                        alignment: .leading,
                        spacing: 14
                    ) {

                        HStack(alignment: .top) {

                            Image(
                                systemName:
                                    "exclamationmark.triangle.fill"
                            )
                            .font(.title3)

                            VStack(
                                alignment: .leading,
                                spacing: 5
                            ) {

                                Text(
                                    "Database Connection Failed"
                                )
                                .font(.headline)

                                Text("Critical Alert")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }

                        Text(
                            "Unable to establish connection with the production database."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        Divider()

                        HStack {

                            Label(
                                "Production",
                                systemImage: "app.fill"
                            )
                            .font(.caption)

                            Spacer()

                            Text("10:42 AM")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                Color(.secondarySystemBackground)
                            )
                    )
                }

                // receipent

                VStack(alignment: .leading, spacing: 10) {

                    Text("Recipient")
                        .font(.headline)

                    HStack(spacing: 10) {

                        Image(
                            systemName: "envelope.fill"
                        )
                        .foregroundStyle(.secondary)

                        TextField(
                            "Enter email address",
                            text: $recipientEmail
                        )
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                Color(.secondarySystemBackground)
                            )
                    )
                }

                // message

                VStack(alignment: .leading, spacing: 10) {

                    Text("Message")
                        .font(.headline)

                    ZStack(alignment: .topLeading) {

                        if message.isEmpty {

                            Text("Add an optional message...")
                                .foregroundStyle(.secondary)
                                .padding(.top, 16)
                                .padding(.leading, 12)
                        }

                        TextEditor(text: $message)
                            .frame(minHeight: 130)
                            .scrollContentBackground(.hidden)
                    }
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                Color(.secondarySystemBackground)
                            )
                    )
                }

                // forward button

                Button {

                    print("Forward Alert tapped")
                    print("Recipient:", recipientEmail)
                    print("Message:", message)

                } label: {

                    HStack {

                        Image(
                            systemName:
                                "arrowshape.turn.up.right.fill"
                        )

                        Text("Forward Alert")
                            .fontWeight(.semibold)

                        Spacer()

                        Image(
                            systemName: "chevron.right"
                        )
                        .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
        .navigationTitle("Forward Alert")
        .navigationBarTitleDisplayMode(.inline)
    }
}
