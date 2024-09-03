//
//  ChallengeAddButtonView.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftUI

struct ChallengeAddButtonView: View {
    @Binding var showPopover: Bool
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Button(action: {
            showPopover = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(currentSchema.barIcons)
                .padding()
                .frame(width: 220, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [6]))
                        .foregroundColor(currentSchema.barIcons)
                )
        }
        .background(.clear)
        .cornerRadius(16)
    }
}
