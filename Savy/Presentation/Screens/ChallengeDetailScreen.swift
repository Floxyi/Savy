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
    
    @State private var showDetailsPopover = false
    @State private var showEditPopover = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
        
        NavigationView {
            VStack() {
                HeaderView(
                    title: challenge.challengeConfiguration.name,
                    size: 32,
                    dismiss: {
                        dismiss()
                        TabBarManager.shared.show()
                    },
                    actionView: AnyView(
                        ChallengeActionMenu(
                            editChallenge: editChallenge,
                            removeChallenge: removeChallenge
                        )
                    )
                )
                .padding(.bottom, 44)
                
                ChallengeInfoView(challenge: challenge)
                    .padding(.top, -18)
                    .padding(.bottom, 48)
                
                VStack {
                    if challenge.remainingAmount() > 0 {
                        SavingsGridView(savings: challenge.savings, columns: columns)
                    }
                    
                    if challenge.remainingAmount() == 0 {
                        CompletionView(removeChallenge: removeChallenge)
                    }
                    
                    Spacer()
                    
                    ChallengeDetailsButtonView(
                        title: "View all",
                        icon: "chevron.up",
                        showPopover: $showDetailsPopover
                    )
                    .padding(.bottom, 24)
                    .popover(isPresented: $showDetailsPopover) {
                        ChallengeDetailsListScreen(challenge: challenge, showPopover: $showDetailsPopover)
                    }
                }

                Spacer()
            }
            .background(currentSchema.background)
        }
        .onAppear(perform: {
            TabBarManager.shared.hide()
        })
        .padding()
        .background(currentSchema.background)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .popover(isPresented: $showEditPopover) {
            ChallengeEditScreen(challenge: challenge, showPopover: $showEditPopover)
        }
    }
    
    private func editChallenge() {
        showEditPopover = true
    }
    
    private func removeChallenge() {
        ChallengeManager.shared.removeChallenge(id: challenge.id)
        dismiss()
        TabBarManager.shared.show()
    }
}

#Preview() {
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let challengeConfiguration = ChallengeConfiguration(
        icon: "homepod",
        name: "HomePod",
        amount: 300,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 12
    )
    ChallengeManager.shared.addChallenge(challengeConfiguration: challengeConfiguration)
    
    return ChallengeDetailScreen(challenge: Challenge(challengeConfiguration: challengeConfiguration))
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
