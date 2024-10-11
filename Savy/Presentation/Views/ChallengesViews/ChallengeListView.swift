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
    
    @State private var showPopover = false
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(ChallengeManager.shared.sortedChallenges()) { challenge in
                    ChallengeListItemView(challenge: challenge)
                }
                ChallengeAddButtonView(showPopover: $showPopover)
            }
        }
        .popover(isPresented: $showPopover) {
            ChallengeAddView(showPopover: $showPopover)
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let startDate = Calendar.current.date(byAdding: .month, value: 2, to: Date())!
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    container.mainContext.insert(Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: 1500, strategy: .Monthly))
    container.mainContext.insert(Challenge(name: "HomePod", icon: "homepod", startDate: Date(), endDate: endDate, targetAmount: 300, strategy: .Monthly))
    container.mainContext.insert(Challenge(name: "AirPods", icon: "airpods.gen3", startDate: startDate, endDate: endDate, targetAmount: 280, strategy: .Monthly))
    
    return ChallengesListView()
        .padding(.top, 80)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
