//
//  ChallengeAddButtonView.swift
//  Savy
//
//  Created by Florian Winkler on 25.09.24.
//

import SwiftData
import SwiftUI

struct ChallengeAddButtonView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    @Binding var showPopover: Bool

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        Button(action: {
            showPopover = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(currentScheme.barIcons)
                .padding()
                .frame(width: 220, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [6]))
                        .foregroundColor(currentScheme.barIcons)
                )
        }
        .background(.clear)
        .cornerRadius(16)
    }
}

#Preview {
    ChallengeAddButtonView(showPopover: .constant(false))
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
