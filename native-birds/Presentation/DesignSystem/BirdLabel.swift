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
                .font(BirdTypography.font(for: style))
                .foregroundStyle(BirdTypography.color(for: style))
                .multilineTextAlignment(BirdTypography.textAlignment(for: style))
                .frame(
                    maxWidth: .infinity,
                    alignment: BirdTypography.alignment(for: style)
                )
        }
}

private struct TypographyCatalog: View {
    let styles: [BirdLabelStyle] = [
        .title, .subtitle, .body, .caption, .listTitle, .listSubtitle
    ]
    
    var body: some View {
        List {
            Section("Design System - Typography") {
                ForEach(styles, id: \.self) { style in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(describing: style).uppercased())
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        BirdLabel(text: "The quick brown fox jumps over the lazy dog", style: style)
                            .border(Color.red.opacity(0.2)) // Auxiliar para ver el frame
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

#Preview("Complete Catalogue") {
    TypographyCatalog()
}

#Preview("Long Text / Multiline") {
    VStack(spacing: 20) {
        BirdLabel(
            text: "This is an example of an extremely long title that should wrap correctly across multiple lines depending on the system configuration.",
            style: .title
        )
        
        BirdLabel(
            text: "The body text must also be legible when the content is extensive, maintaining the line spacing defined in the Native Birds design system.",
            style: .body
        )
    }
    .padding()
}

