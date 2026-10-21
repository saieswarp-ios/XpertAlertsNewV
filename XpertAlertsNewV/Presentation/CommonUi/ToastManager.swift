//
//  ToastManager.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 21/10/26.
//


import SwiftUI
import Combine

@MainActor
final class ToastManager: ObservableObject {

    @Published var message: String?

    private var hideTask: Task<Void, Never>?

    func show(_ message: String) {
        hideTask?.cancel()

        self.message = message

        hideTask = Task { [weak self] in
            try? await Task.sleep(
                nanoseconds: 2_500_000_000
            )

            guard !Task.isCancelled else {
                return
            }

            self?.message = nil
        }
    }

    func dismiss() {
        hideTask?.cancel()
        message = nil
    }
}

private struct ToastBanner: View {

    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")

            Text(message)
                .font(.subheadline.weight(.medium))
                .multilineTextAlignment(.leading)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color.green.opacity(0.95),
            in: RoundedRectangle(cornerRadius: 14)
        )
        .shadow(radius: 5)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .accessibilityElement(children: .combine)
    }
}

struct ToastPresenter: ViewModifier {

    @ObservedObject var manager: ToastManager

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let message = manager.message {
                    ToastBanner(message: message)
                        .transition(
                            .move(edge: .bottom)
                                .combined(with: .opacity)
                        )
                        .onTapGesture {
                            manager.dismiss()
                        }
                }
            }
            .animation(
                .easeInOut(duration: 0.25),
                value: manager.message
            )
    }
}
