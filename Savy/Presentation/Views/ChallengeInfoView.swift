//
//  ChallengeInfoView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftUI

struct ChallengeInfoView: View {
    let challenge: Challenge
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack(alignment: .center, spacing: 16) {
            HeaderView(title: "Challenge")

            Spacer()

            Text("Challenge: \(challenge.name)")
                .font(.headline)
            Image(systemName: challenge.icon)
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
