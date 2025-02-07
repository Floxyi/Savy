//
//  ToolbarDoneButton.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct ToolbarDoneButton: View {
    @Binding var showPopover: Bool

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    let title: String
    let isValid: () -> Bool
    let onDoneAction: () -> Void

    public var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        Button(action: {
            if isValid() {
                onDoneAction()
                showPopover = false
            }
        }) {
            Text(title)
                .foregroundColor(!isValid() ? currentScheme.barIcons.opacity(0.4) : currentScheme.barIcons)
                .font(.system(size: 16, weight: !isValid() ? .regular : .bold))
        }
        .disabled(!isValid())
    }
}
