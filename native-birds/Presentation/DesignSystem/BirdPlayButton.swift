//
//  BirdPlayButton.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI

struct BirdPlayButton: View {
    let audioState: BirdAudioUIState
    let action: () -> Void

    private let buttonSize: CGFloat = BirdSpacing.large
    private let ringWidth: CGFloat = 4

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(BirdTheme.accentYellow)
                    .frame(width: buttonSize, height: buttonSize)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)

                if case .downloading(let progress) = audioState {
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(
                            BirdTheme.deepBlack,
                            style: StrokeStyle(lineWidth: ringWidth, lineCap: .round)
                        )
                        .frame(width: buttonSize - ringWidth, height: buttonSize - ringWidth)
                        .rotationEffect(.degrees(-90))
                        .opacity(1.0)
                        .animation(.linear, value: progress)
                }

                content
                    .foregroundColor(BirdTheme.deepBlack)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }

    @ViewBuilder
    private var content: some View {
        switch audioState {
        case .playing:
            Image(systemName: "pause.fill")
                .font(.system(size: 24, weight: .bold))
        case .downloading:
            ProgressView()
                .controlSize(.small)
        default:
            Image(systemName: "play.fill")
                .font(.system(size: 24, weight: .bold))
                .offset(x: 2)
        }
    }

    private var isEnabled: Bool {
        switch audioState {
        case .ready, .playing, .paused: return true
        default: return false
        }
    }
}


#Preview("Play Button States") {
    VStack(spacing: 40) {
        HStack(spacing: 30) {
            VStack {
                Text("Idle").font(.caption)
                BirdPlayButton(audioState: .idle, action: {})
            }
            
            VStack {
                Text("Ready").font(.caption)
                BirdPlayButton(audioState: .ready(localFileURL: URL(fileURLWithPath: "")), action: {})
            }
        }

        HStack(spacing: 30) {
            VStack {
                Text("40% Download").font(.caption)
                BirdPlayButton(audioState: .downloading(progress: 0.4), action: {})
            }
            
            VStack {
                Text("90% Download").font(.caption)
                BirdPlayButton(audioState: .downloading(progress: 0.9), action: {})
            }
        }

        HStack(spacing: 30) {
            VStack {
                Text("Playing").font(.caption)
                BirdPlayButton(audioState: .playing(localFileURL: URL(fileURLWithPath: "")), action: {})
            }
            
            VStack {
                Text("Paused").font(.caption)
                BirdPlayButton(audioState: .paused(localFileURL: URL(fileURLWithPath: "")), action: {})
            }
        }
    }
    .padding(40)
    .background(Color.gray.opacity(0.1))
}
