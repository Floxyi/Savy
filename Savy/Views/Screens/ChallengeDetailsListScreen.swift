//
//  ChallengeDetailsListScreen.swift
//  Savy
//
//  Created by Florian Winkler on 11.10.24.
//

import SwiftData
import SwiftUI

struct ChallengeDetailsListScreen: View {
    let challenge: Challenge
    @Binding var showPopover: Bool

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme
        let columns = Array(repeating: GridItem(.flexible()), count: 4)
        let sortedSavings = challenge.savings.sorted(by: { $0.date < $1.date })

        NavigationStack {
            VStack {
                ChallengeDetailsButtonView(title: "Hide", icon: "chevron.down", showPopover: $showPopover)
                    .padding(.top, -36)
                    .padding(.bottom, 4)

                HeaderView(title: "Savings Overview", size: 38)
                    .padding(.bottom, -1)

                HStack {
                    Text("Start:")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(currentScheme.font)
                    Text(challenge.challengeConfiguration.startDate.formatted(.dateTime.day().month().year()))
                        .font(.system(size: 16))
                        .foregroundColor(currentScheme.font)
                    Spacer()
                    Text("End:")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(currentScheme.font)
                    Text(challenge.challengeConfiguration.endDate.formatted(.dateTime.day().month().year()))
                        .font(.system(size: 16))
                        .foregroundColor(currentScheme.font)
                }
                .padding(.horizontal, 20)
                .padding(.top, 1)

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(sortedSavings, id: \.id) { saving in
                            SavingItemView(saving: saving)
                        }
                    }
                }
                .padding(.top, 20)
                .background(currentScheme.background)

                Spacer()
                HStack {
                    Spacer()
                }
            }
            .padding()
            .background(currentScheme.background)
        }
    }
}

#Preview {
    @Previewable @State var showPopover = true

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

    return Spacer()
        .popover(isPresented: $showPopover) {
            ChallengeDetailsListScreen(challenge: Challenge(challengeConfiguration: challengeConfiguration), showPopover: $showPopover)
        }
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
