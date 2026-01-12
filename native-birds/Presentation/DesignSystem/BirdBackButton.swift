//
//  BirdBackButton.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI

struct BirdBackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .padding(.leading, BirdSpacing.screenHorizontal)
        .padding(.top, 16)
    }
}
