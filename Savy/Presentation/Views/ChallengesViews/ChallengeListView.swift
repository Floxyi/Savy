//
//  ChallengeListView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftUI
import SwiftData

struct ChallengesListView: View {
    let challenges: [Challenge]
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var showPopover = false
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(challenges) { challenge in
                    ChallengeListItemView(challenge: challenge)
                }
                .onDelete(perform: deleteItems)
                ChallengeAddButton(showPopover: $showPopover)
            }
        }
        .popover(isPresented: $showPopover) {
            ChallengeAddView(showPopover: $showPopover)
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

private struct ChallengeAddButton: View {
    @Binding var showPopover: Bool
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Button(action: {
            showPopover = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(currentSchema.barIcons)
                .padding()
                .frame(width: 220, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [6]))
                        .foregroundColor(currentSchema.barIcons)
                )
        }
        .background(.clear)
        .cornerRadius(16)
    }
}

#Preview {
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let endDate = Calendar.current.date(byAdding: .month, value: 12, to: Date())!
    
    var challenges: [Challenge] = []
    let challenge1: Challenge = Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: 1500)
    let challenge2: Challenge = Challenge(name: "HomePod", icon: "homepod", startDate: Date(), endDate: endDate, targetAmount: 300)
    let challenge3: Challenge = Challenge(name: "AirPods", icon: "airpods.gen3", startDate: Date(), endDate: endDate, targetAmount: 280)
    
    challenges.append(challenge1)
    challenges.append(challenge2)
    challenges.append(challenge3)
    
    container.mainContext.insert(challenge1)
    container.mainContext.insert(challenge2)
    container.mainContext.insert(challenge3)
    
    return ChallengesListView(challenges: challenges)
        .padding(.top, 80)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
