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
                HeaderView(title: challenge.name, dismiss: {
                    dismiss()
                    tabBarManager.show()
                })
                
                ChallengeInfoView(challenge: challenge)
                    .padding(.top, -36)
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
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    let challenge: Challenge = Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: 1500)
    
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(challenge)
    
    return ChallengeDetailScreen(challenge: challenge)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
        .environmentObject(TabBarManager())
}
