//
//  CustomEmailFieldStyle.swift
//  Savy
//
//  Created by Nadine Schatz on 01.09.24.
//

import SwiftUI

struct CustomEmailFieldStyle: TextFieldStyle {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    func _body(configuration: TextField<Self._Label>) -> some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        configuration
            .keyboardType(.emailAddress)
            .padding(4)
            .cornerRadius(8)
            .padding()
            .background(
                VStack {
                    Spacer()
                    Color(currentSchema.bar)
                }
            )
    }
}
