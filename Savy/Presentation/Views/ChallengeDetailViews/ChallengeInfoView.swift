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
        
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            
            HStack {
                Image(systemName: challenge.icon)
                Text(challenge.name)
                    .font(.headline)
            }
            Text("Start Date: \(challenge.startDate.formatted())")
                .font(.subheadline)
            Text("End Date: \(challenge.endDate.formatted())")
                .font(.subheadline)
            Text("Amount: \(challenge.targetAmount)")
                .font(.subheadline)

            Spacer()
        }
        .foregroundStyle(currentSchema.font)
        .padding()
    }
}

#Preview {
    let endDate: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date())!
    return ChallengeInfoView(challenge: Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: 1500))
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
