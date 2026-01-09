//
//  PrimaryButton.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import SwiftUI

enum PrimaryButtonState: Equatable {
    case normal
    case loading
    case disabled
}

struct PrimaryButton: View {
    let title: String
    let state: PrimaryButtonState
    let action: () -> Void

    init(
        title: String,
        state: PrimaryButtonState = .normal,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.state = state
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if state == .loading {
                    ProgressView()
                        .tint(BirdTheme.deepBlack)
                }

                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(BirdTheme.deepBlack)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .background(BirdTheme.accentYellow)
            .clipShape(Capsule())
            .shadow(
                color: .black.opacity(0.20),
                radius: 10,
                x: 0,
                y: 6
            )
            .opacity(state == .disabled ? 0.6 : 1.0)
        }
        .disabled(state != .normal)
    }
}

#Preview("PrimaryButton") {
    VStack {
        PrimaryButton(
            title: "Start Adventure",
            state: .normal
        ) { }
        .padding()
        
        PrimaryButton(
            title: "Loading...",
            state: .loading
        ) { }
        .padding()
        
        PrimaryButton(
            title: "Disabled",
            state: .disabled
        ) { }
        .padding()
    }
}
