//
//  ToolbarDoneButton.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct ToolbarDoneButton: View {
    @Binding var showPopover: Bool
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var challengeConfiguration: ChallengeConfiguration
    
    public var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Button(action: {
            if challengeConfiguration.isValid() {
                showPopover = false
                modelContext.insert(challengeConfiguration.createChallenge())
            }
        }) {
            Text("Done")
                .foregroundColor(!challengeConfiguration.isValid() ? currentSchema.barIcons.opacity(0.4) : currentSchema.barIcons)
        }
        .disabled(!challengeConfiguration.isValid())
    }
}
