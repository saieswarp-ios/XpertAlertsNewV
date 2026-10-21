
import SwiftUI

struct AboutView: View {

    @Environment(\.dismiss) private var dismiss

    private let themeOrange = Color(
        red: 0.929,
        green: 0.455,
        blue: 0.110
    )

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header

            HStack(spacing: 12) {

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(themeOrange)
                        .frame(width: 28, height: 40)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")

                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(themeOrange)
                    .frame(width: 40, height: 40)
                    .background(themeOrange.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text("About")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(themeOrange)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 16)

            // MARK: - About Content

            Spacer()

            VStack(spacing: 20) {
                Image("XpertAlerts")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 280, maxHeight: 160)
                    .padding(.horizontal, 20)

                VStack(spacing: 8) {
                    Text("XpertAlerts")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.primary)

                    Text("App Version: v1.7")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Text("Copyright © 2020, Aquila Software Inc.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
    }
}

