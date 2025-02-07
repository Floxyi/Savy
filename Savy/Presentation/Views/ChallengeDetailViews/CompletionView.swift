//
//  CompletionView.swift
//  Savy
//
//  Created by Florian Winkler on 21.10.24.

import SwiftUI

struct CompletionView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var removeChallenge: () -> Void

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        VStack {
            Image(systemName: "flag.pattern.checkered.2.crossed")
                .font(.system(size: 100, weight: .bold))
                .foregroundStyle(currentScheme.font)
            Text("Congratulations! \nYou've reached your goal!")
                .font(.system(size: 24))
                .foregroundStyle(currentScheme.font)
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
            Button(role: .destructive, action: {
                removeChallenge()
            }) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
