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

    private let buttonSize: CGFloat = 88
    private let iconSize: CGFloat = 38
    private let ringWidth: CGFloat = 6

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(BirdTheme.accentYellow)
                    .frame(width: buttonSize, height: buttonSize)
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)

                if case .downloading(let progress) = audioState {
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(
                            BirdTheme.deepBlack,
                            style: StrokeStyle(lineWidth: ringWidth, lineCap: .round)
                        )
                        .frame(width: buttonSize - ringWidth, height: buttonSize - ringWidth)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.2), value: progress)
                }

                content
                    .foregroundColor(BirdTheme.deepBlack)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .scaleEffect(isEnabled ? 1.0 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isEnabled)
    }

    @ViewBuilder
    private var content: some View {
        switch audioState {
        case .playing:
            Image(systemName: "pause.fill")
                .font(.system(size: iconSize, weight: .black))
        case .downloading, .idle:
            ProgressView()
                .controlSize(.regular)
                .tint(BirdTheme.deepBlack)
        default:
            Image(systemName: "play.fill")
                .font(.system(size: iconSize, weight: .black))
                .offset(x: 4)
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
