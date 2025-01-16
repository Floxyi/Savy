//
//  ToolbarDoneButton.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct ToolbarDoneButton: View {
    @Binding var showPopover: Bool

    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    let title: String
    let isValid: () -> Bool
    let onDoneAction: () -> Void

    public var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        Button(action: {
            if isValid() {
                onDoneAction()
                showPopover = false
            }
        }) {
            Text(title)
                .foregroundColor(!isValid() ? currentSchema.barIcons.opacity(0.4) : currentSchema.barIcons)
                .font(.system(size: 16, weight: !isValid() ? .regular : .bold))
        }
        .disabled(!isValid())
    }
}
