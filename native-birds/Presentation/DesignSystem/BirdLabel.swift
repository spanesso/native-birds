//
//  BirdLabel.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import SwiftUI

enum BirdLabelStyle {
    case title
    case subtitle
    case body
    case caption
    case listTitle
    case listSubtitle
}

struct BirdLabel: View {

    let text: String
    let style: BirdLabelStyle

    init(
        text: String,
        style: BirdLabelStyle
    ) {
        self.text = text
        self.style = style
    }

    var body: some View {
        Text(text)
            .font(
                BirdTypography.font(for: style)
            )
            .foregroundStyle(BirdTypography.color(for: style))
            .frame(
                maxWidth: .infinity,
                alignment: BirdTypography.alignment(for: style)
            )
    }
}
