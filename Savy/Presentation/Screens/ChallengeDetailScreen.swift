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
        let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
        let sortedChallenges = challenge.savings.filter { !$0.done }.sorted(by: { $0.date < $1.date })
        
        NavigationView {
            VStack() {
                HeaderView(title: challenge.name, dismiss: {
                    dismiss()
                    tabBarManager.show()
                })
                
                ChallengeInfoView(challenge: challenge)
                    .padding(.top, -18)
                    .padding(.bottom, 24)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(sortedChallenges.prefix(15), id: \.id) { saving in
                        SavingItemView(saving: saving)
                    }
                    if sortedChallenges.count - 15 > 1 {
                        VStack {
                            Text("\(sortedChallenges.count - 15)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(currentSchema.font)
                            Text("more")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(currentSchema.font)
                        }
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [5]))
                                .foregroundColor(currentSchema.font)
                        )
                    } else if sortedChallenges.count - 15 == 1 {
                        SavingItemView(saving: sortedChallenges.last!)
                    }
                }
                .padding(.top, -500)
                
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
    let challenge: Challenge = Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: 500, strategy: .Monthly)
    
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(challenge)
    
    return ChallengeDetailScreen(challenge: challenge)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
        .environmentObject(TabBarManager())
}
