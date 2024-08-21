//
//  ChallengeView.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftUI

struct ChallengeDetailView: View {
    let challenge: Challenge

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Challenge: \(challenge.name)")
                .font(.headline)
            Text("Date: \(challenge.date.formatted())")
                .font(.subheadline)
            Text("Notifications: \(challenge.notifications ? "Enabled" : "Disabled")")
                .font(.subheadline)
            Spacer()
        }
        .padding()
        .navigationTitle("Challenge Details")
    }
}
