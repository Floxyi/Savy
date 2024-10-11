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
                .onDelete(perform: deleteItem)
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
            let nextSaving1 = challenge1.getNextSaving(at: 1)
            let nextSaving2 = challenge2.getNextSaving(at: 1)
            
            let dateComponents1 = DateComponents(
                year: calendar.component(.year, from: nextSaving1.date),
                month: calendar.component(.month, from: nextSaving1.date),
                day: calendar.component(.day, from: nextSaving1.date)
            )
            let dateComponents2 = DateComponents(
                year: calendar.component(.year, from: nextSaving2.date),
                month: calendar.component(.month, from: nextSaving2.date),
                day: calendar.component(.day, from: nextSaving2.date)
            )
            
            let date1 = calendar.date(from: dateComponents1) ?? Date()
            let date2 = calendar.date(from: dateComponents2) ?? Date()
            
            let remainingSavings1 = challenge1.remainingSavings()
            let remainingSavings2 = challenge2.remainingSavings()
            
            if remainingSavings1 == 0 && remainingSavings2 == 0 {
                return challenge1.endDate < challenge2.endDate
            }
            
            if remainingSavings1 == 0 { return false }
            if remainingSavings2 == 0 { return true }
            
            return date1 == date2
            ? nextSaving1.amount < nextSaving2.amount
            : date1 < date2
        }
    }
    
    private func deleteItem(offsets: IndexSet) {
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
    
    let startDate = Calendar.current.date(byAdding: .month, value: 2, to: Date())!
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    container.mainContext.insert(Challenge(
        name: "MacBook",
        icon: "macbook",
        startDate: Date(),
        endDate: endDate,
        targetAmount: 1500,
        strategy: .Monthly,
        calculation: .Amount,
        savingAmount: 12
    ))
    container.mainContext.insert(Challenge(
        name: "HomePod",
        icon: "homepod",
        startDate: Date(),
        endDate: endDate,
        targetAmount: 300,
        strategy: .Monthly,
        calculation: .Date
    ))
    container.mainContext.insert(Challenge(
        name: "AirPods",
        icon: "airpods.gen3",
        startDate: startDate,
        endDate: endDate,
        targetAmount: 280,
        strategy: .Monthly,
        calculation: .Amount,
        savingAmount: 10
    ))
    
    return ChallengesListView()
        .padding(.top, 80)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
