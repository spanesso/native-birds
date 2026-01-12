//
//  BottomSheetGrabber.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 12/01/26.
//

import SwiftUI

private struct BottomSheetGrabber: View {

    var body: some View {
        Capsule()
            .fill(Color.black.opacity(0.2))
            .frame(width: 42, height: 6)
            .padding(.top, BirdSpacing.contentVertical)
    }
}
