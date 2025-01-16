//
//  CustomPromptTextStyle.swift
//  Savy
//
//  Created by Nadine Schatz on 01.09.24.
//

import SwiftUI

struct CustomPromptTextStyle: TextFieldStyle {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    func _body(configuration: TextField<Self._Label>) -> some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        configuration
            .foregroundColor(currentSchema.font.opacity(0.4))
        }
}

