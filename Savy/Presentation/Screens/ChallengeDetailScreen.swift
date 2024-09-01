//
//  ChallengeDetailScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct ChallengeDetailScreen: View {
    let challenge: Challenge
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            ChallengeInfoView(challenge: challenge)
            Spacer()
            HStack {
                Spacer()
            }
        }
        .background(currentSchema.background)
    }
}

#Preview {
    ChallengeDetailScreen(challenge: Challenge(name: "Text Challenge", date: Date(), notifications: true))
        .modelContainer(for: [Challenge.self, ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
