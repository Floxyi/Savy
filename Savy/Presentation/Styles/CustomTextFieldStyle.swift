//
//  CustomTextFieldStyle.swift
//  Savy
//
//  Created by Nadine Schatz on 01.09.24.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    func _body(configuration: TextField<Self._Label>) -> some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        configuration
            .padding(8)
            .background(currentScheme.bar)
            .cornerRadius(8)
            .foregroundColor(currentScheme.font)
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
    }
}
