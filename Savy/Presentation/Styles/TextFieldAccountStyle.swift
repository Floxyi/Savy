//
//  TextFieldAccountStyle.swift
//  Savy
//
//  Created by Nadine Schatz on 01.09.24.
//

import SwiftUI

struct TextFieldAccountStyle: TextFieldStyle {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    func _body(configuration: TextField<Self._Label>) -> some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        configuration
            .padding(8)
            .background(currentSchema.bar)
            .cornerRadius(10)
            .foregroundColor(currentSchema.font)
            .font(.system(size: 20))
            .padding(.vertical, 4)
            .padding(.horizontal, 24)
    }
}
