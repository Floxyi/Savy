//
//  CustomToggleStyle.swift
//  Savy
//
//  Created by Florian Winkler on 28.08.24.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    func makeBody(configuration: Configuration) -> some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        HStack {
            configuration.label

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? currentSchema.accent2 : currentSchema.background)
                    .frame(width: 51, height: 31)

                Circle()
                    .fill(currentSchema.bar)
                    .frame(width: 27, height: 27)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}
