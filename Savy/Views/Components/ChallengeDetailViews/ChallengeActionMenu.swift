//
//  ChallengeActionMenu.swift
//  Savy
//
//  Created by Florian Winkler on 21.10.24.

import SwiftUI

struct ChallengeActionMenu: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var editChallenge: () -> Void
    var removeChallenge: () -> Void
    var iconSize: CGFloat = 24

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

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
                .font(.system(size: iconSize, weight: .bold))
                .foregroundColor(currentScheme.font)
        }
    }
}

#Preview {
    ChallengeActionMenu(
        editChallenge: {},
        removeChallenge: {}
    )
}
