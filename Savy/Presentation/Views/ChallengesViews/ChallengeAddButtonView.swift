//
//  ChallengeAddButtonView.swift
//  Savy
//
//  Created by Florian Winkler on 25.09.24.
//

import SwiftData
import SwiftUI

struct ChallengeAddButtonView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    @Binding var showPopover: Bool

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

#Preview {
    ChallengeAddButtonView(showPopover: .constant(false))
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
