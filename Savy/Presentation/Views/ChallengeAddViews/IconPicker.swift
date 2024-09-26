//
//  IconPicker.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct IconPicker: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    @Binding var selectedIcon: String?
    
    public var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            Text("Choose icon")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(currentSchema.font)
                .multilineTextAlignment(.center)
        }
        .frame(width: 75, height: 75)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [5]))
                .foregroundColor(currentSchema.font)
        )
        .padding(.bottom, 16)
    }
}
