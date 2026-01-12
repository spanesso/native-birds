//
//  BirdsListFeedbackView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI

struct BirdsListFeedbackView: View {
    
    let text: String
    let actionTitle: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: BirdSpacing.sectionVertical) {
            BirdLabel(
                text: text,
                style: .subtitle
            )
            .multilineTextAlignment(.center)
            
            BirdButton(
                title: actionTitle,
                state: .normal,
                action: onRetry
            )
            .padding(.horizontal, BirdSpacing.screenHorizontal)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
        .multilineTextAlignment(.center)
        .padding(.horizontal, BirdSpacing.screenHorizontal)
    }
}
