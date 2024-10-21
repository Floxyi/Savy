//
//  CompletionView.swift
//  Savy
//
//  Created by Florian Winkler on 21.10.24.

import SwiftUI

struct CompletionView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var removeChallenge: () -> Void

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            Image(systemName: "flag.pattern.checkered.2.crossed")
                .font(.system(size: 100, weight: .bold))
                .foregroundStyle(currentSchema.font)
            Text("Congratulations! \nYou've reached your goal!")
                .font(.system(size: 24))
                .foregroundStyle(currentSchema.font)
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
