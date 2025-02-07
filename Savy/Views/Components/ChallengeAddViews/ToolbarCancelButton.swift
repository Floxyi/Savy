//
//  ToolbarCancelButton.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct ToolbarCancelButton: View {
    @Binding var showPopover: Bool

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    public var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        Button("Cancel") {
            showPopover = false
        }
        .font(.system(size: 16))
        .foregroundStyle(currentScheme.barIcons)
    }
}
