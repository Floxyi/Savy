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
        VStack(alignment: .center, spacing: 16) {
            HeaderView(title: "Challenge")

            Spacer()

            Text("Challenge: \(challenge.name)")
                .font(.headline)
            Text("Date: \(challenge.date.formatted())")
                .font(.subheadline)
            Text("Notifications: \(challenge.notifications ? "Enabled" : "Disabled")")
                .font(.subheadline)

            Spacer()
        }
        .foregroundStyle(colorManagerVM.colorManager.currentSchema.font)
        .padding()
    }
}
