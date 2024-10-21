//
//  ChallengeActionMenu.swift
//  Savy
//
//  Created by Florian Winkler on 21.10.24.

import SwiftUI

struct ChallengeActionMenu: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var editChallenge: () -> Void
    var removeChallenge: () -> Void

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Menu {
            Button(action: {
                editChallenge()
            }) {
                Label("Edit", systemImage: "pencil")
            }
            Button(role: .destructive, action: {
                removeChallenge()
            }) {
                Label("Delete", systemImage: "trash")
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(currentSchema.font)
        }
    }
}

#Preview {
    ChallengeActionMenu(
        editChallenge: {},
        removeChallenge: {}
    )
}
