//
//  ChallengeInfoView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftData
import SwiftUI

struct ChallengeInfoView: View {
    let challenge: Challenge
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack() {
            VStack {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(currentSchema.accent2)
                    Text("Start: \(challenge.startDate.formatted(.dateTime.year().month(.twoDigits).day()))")
                        .font(.system(size: 14))
                        .foregroundStyle(currentSchema.font)
                    Spacer()
                    Image(systemName: "calendar.badge.checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(currentSchema.accent2)
                    Text("End: \(challenge.endDate.formatted(.dateTime.year().month(.twoDigits).day()))")
                        .font(.system(size: 14))
                        .foregroundStyle(currentSchema.font)
                }
                
                ChallengeProgressBarView(challenge: challenge)
                
                HStack {
                    Spacer()
                    Text("\(challenge.remainingSavings()) savings to go")
                        .font(.system(size: 12))
                        .foregroundStyle(currentSchema.font)
                }
                
            }
            .padding(16)
            .background(currentSchema.bar)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            Spacer()
        }
    }
}

#Preview {
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    let challenge: Challenge = Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: 1500, strategy: .Monthly)
    
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(challenge)
    
    return ChallengeInfoView(challenge: challenge)
        .padding()
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}
