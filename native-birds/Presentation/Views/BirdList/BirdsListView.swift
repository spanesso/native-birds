//
//  BirdsListView.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import SwiftUI

struct BirdsListView: View {
    var body: some View {
        ZStack {
            BirdTheme.surfaceWhite.ignoresSafeArea()
            Text("Pending View")
                .foregroundStyle(BirdTheme.deepBlack)
        }
        .navigationTitle("Nearby Birds")
    }
}
