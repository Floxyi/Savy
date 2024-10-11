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
    
    @State private var showPopover = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    @EnvironmentObject private var tabBarManager: TabBarManager
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
        let sortedSavings = challenge.savings.filter { !$0.done }.sorted(by: { $0.date < $1.date })
        
        NavigationView {
            VStack() {
                HeaderView(
                    title: challenge.name,
                    size: 32,
                    dismiss: {
                        dismiss()
                        tabBarManager.show()
                    },
                    actionView: AnyView(
                        Menu {
                            Button(action: {
                                editChallenge()
                            }) {
                                Label("Edit", systemImage: "pencil")
                            }
                            Button(role: .destructive, action: {
                                deleteChallenge()
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(currentSchema.font)
                        }
                    )
                )
                .padding(.bottom, 44)
                
                ChallengeInfoView(challenge: challenge)
                    .padding(.top, -18)
                    .padding(.bottom, 48)
                
                VStack {
                    if challenge.remainingAmount() > 0 {
                        VStack {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(sortedSavings.prefix(15), id: \.id) { saving in
                                    SavingItemView(saving: saving)
                                }
                                if sortedSavings.count - 15 > 1 {
                                    VStack {
                                        Text("\(sortedSavings.count - 15)")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundStyle(currentSchema.barIcons)
                                        Text("more")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundStyle(currentSchema.barIcons)
                                    }
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [5]))
                                            .foregroundColor(currentSchema.barIcons)
                                    )
                                } else if sortedSavings.count - 15 == 1 {
                                    SavingItemView(saving: sortedSavings.last!)
                                }
                            }
                            ChallengeDetailsButtonView(
                                title: "View all",
                                icon: "chevron.up",
                                showPopover: $showPopover
                            )
                            .popover(isPresented: $showPopover) {
                                ChallengeDetailsListScreen(challenge: challenge, showPopover: $showPopover)
                            }
                        }
                    }
                    
                    if challenge.remainingAmount() == 0 {
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
                                deleteChallenge()
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                Spacer()
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
    
    private func editChallenge() {
    }
    
    private func deleteChallenge() {
        modelContext.delete(challenge)
        for saving in challenge.savings {
            modelContext.delete(saving)
        }
        try? modelContext.save()
        
        dismiss()
        tabBarManager.show()
    }
}

#Preview("Running") {
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    let challenge: Challenge = Challenge(
        name: "MacBook",
        icon: "macbook",
        startDate: Date(),
        endDate: endDate,
        targetAmount: 200,
        strategy: .Monthly,
        calculation: .Amount,
        savingAmount: 12
    )
    
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(challenge)
    
    return ChallengeDetailScreen(challenge: challenge)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
        .environmentObject(TabBarManager())
}

#Preview("Finished") {
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    let challenge: Challenge = Challenge(
        name: "MacBook",
        icon: "macbook",
        startDate: Date(),
        endDate: endDate,
        targetAmount: 200,
        strategy: .Monthly,
        calculation: .Amount,
        savingAmount: 12
    )
    
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(challenge)
    
    return ChallengeDetailScreen(challenge: challenge)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
        .environmentObject(TabBarManager())
}
