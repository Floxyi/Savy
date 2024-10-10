//
//  ChallengeListView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftUI
import SwiftData

struct ChallengesListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var challenges: [Challenge]
    
    @State private var showPopover = false
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(sortedChallenges()) { challenge in
                    ChallengeListItemView(challenge: challenge)
                }
                .onDelete(perform: deleteItems)
                ChallengeAddButtonView(showPopover: $showPopover)
            }
        }
        .popover(isPresented: $showPopover) {
            ChallengeAddView(showPopover: $showPopover)
        }
    }
    
    private func sortedChallenges() -> [Challenge] {
        let calendar = Calendar.current
        return challenges.sorted { challenge1, challenge2 in
            let nextSaving1 = challenge1.getNextSaving()
            let nextSaving2 = challenge2.getNextSaving()
            
            let dateComponents1 = (
                day: calendar.component(.day, from: nextSaving1.date),
                month: calendar.component(.month, from: nextSaving1.date)
            )
            let dateComponents2 = (
                day: calendar.component(.day, from: nextSaving2.date),
                month: calendar.component(.month, from: nextSaving2.date)
            )
            
            let remainingSavings1 = challenge1.remainingSavings()
            let remainingSavings2 = challenge2.remainingSavings()
            
            if remainingSavings1 == 0 && remainingSavings2 == 0 {
                return challenge1.endDate < challenge2.endDate
            }
            if remainingSavings1 == 0 { return false }
            if remainingSavings2 == 0 { return true }
            
            return dateComponents1 == dateComponents2
                ? nextSaving1.amount < nextSaving2.amount
                : dateComponents1 < dateComponents2
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(challenges[index])
                do {
                    try modelContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    container.mainContext.insert(Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: 1500, strategy: .Monthly))
    container.mainContext.insert(Challenge(name: "HomePod", icon: "homepod", startDate: Date(), endDate: endDate, targetAmount: 300, strategy: .Monthly))
    container.mainContext.insert(Challenge(name: "AirPods", icon: "airpods.gen3", startDate: Date(), endDate: endDate, targetAmount: 280, strategy: .Monthly))
    
    return ChallengesListView()
        .padding(.top, 80)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
