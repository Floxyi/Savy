//
//  CustomToggleStyle.swift
//  Savy
//
//  Created by Florian Winkler on 28.08.24.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    func makeBody(configuration: Configuration) -> some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack {
            configuration.label

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(currentScheme.bar)
                    .frame(width: 51, height: 31)

                Circle()
                    .fill(currentScheme.background)
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
