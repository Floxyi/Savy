//
//  CustomTextFieldStyle.swift
//  Savy
//
//  Created by Nadine Schatz on 01.09.24.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        configuration
            .padding(8)
            .background(currentSchema.bar)
            .cornerRadius(8)
            .foregroundColor(currentSchema.font)
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
    }
}
