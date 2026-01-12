//
//  BirdWikipediaSection.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI
import Foundation

private struct BirdWikipediaSection: View {

    let url: URL?

    var body: some View {
        Group {
            if let url {
                Button {
                    UIApplication.shared.open(url)
                } label: {
                    HStack(spacing: BirdSpacing.listItemTextSpacing) {
                        Image(systemName: "link")
                        Text("Open Wikipedia")
                            .font(BirdTypography.font(for: .body))
                    }
                    .foregroundColor(BirdTheme.electricBlue)
                }
                .padding(.top, BirdSpacing.sectionVertical)
            }
        }
    }
}
