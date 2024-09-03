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
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    @EnvironmentObject private var tabBarManager: TabBarManager
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        NavigationView {
            VStack {
                HeaderView(title: "Challenge", dismiss: {
                    dismiss()
                    tabBarManager.show()
                })
                
                ChallengeInfoView(challenge: challenge)
            }
            .background(currentSchema.background)
        }
        .onAppear(perform: {
            tabBarManager.hide()
        })
        .padding()
        .background(currentSchema.background)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }
}

#Preview {
    ChallengeDetailScreen(
        challenge: Challenge(
            name: "MacBook",
            icon: "macbook",
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .month, value: 6, to: Date())!,
            targetAmount: 1500
        )
    )
    .modelContainer(for: [Challenge.self, ColorManager.self])
    .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
    .environmentObject(TabBarManager())
}
