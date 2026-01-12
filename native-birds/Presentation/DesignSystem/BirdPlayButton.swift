//
//  BirdPlayButton.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI

private struct BirdPlayButton: View {

    let audioState: BirdAudioUIState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(BirdTheme.accentYellow)
                    .frame(
                        width: BirdSpacing.large,
                        height: BirdSpacing.large
                    )
                    .shadow(radius: 12)

                content
            }
        }
        .disabled(!isEnabled)
    }

    @ViewBuilder
    private var content: some View {
        switch audioState {

        case .downloading(let progress):
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.black, lineWidth: 5)
                .rotationEffect(.degrees(-90))

        case .playing:
            Image(systemName: "pause.fill")
                .font(.system(size: 28, weight: .bold))

        default:
            Image(systemName: "play.fill")
                .font(.system(size: 28, weight: .bold))
        }
    }

    private var isEnabled: Bool {
        switch audioState {
        case .ready, .playing, .paused:
            return true
        default:
            return false
        }
    }
}
