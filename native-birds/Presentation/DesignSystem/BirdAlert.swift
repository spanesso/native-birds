//
//  BirdAlertModifier.swift
//  native-birds
//
//  Created by PANESSO Alfredo Sebastian on 9/01/26.
//

import SwiftUI

import SwiftUI

extension View {

    func birdAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButtonTitle: String = AppCopy.Global.retry,
        secondaryButtonTitle: String? = AppCopy.Global.cancel,
        onPrimaryAction: @escaping () -> Void
    ) -> some View {
        modifier(
            BirdAlertModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                primaryButtonTitle: primaryButtonTitle,
                secondaryButtonTitle: secondaryButtonTitle,
                onPrimaryAction: onPrimaryAction
            )
        )
    }
}


struct BirdAlertModifier: ViewModifier {

    @Binding var isPresented: Bool

    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    let onPrimaryAction: () -> Void

    func body(content: Content) -> some View {
        content.alert(title, isPresented: $isPresented) {
            Button(primaryButtonTitle) {
                onPrimaryAction()
            }

            if let secondary = secondaryButtonTitle {
                Button(secondary, role: .cancel) { }
            }
        } message: {
            BirdLabel(
                text: message,
                style: .caption
            )
        }
    }
}
