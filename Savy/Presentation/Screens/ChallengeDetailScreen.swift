//
//  ChallengeView.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftUI

struct ChallengeDetailScreen: View {
    let challenge: Challenge

    var body: some View {
        ChallengeInfoView(challenge: challenge)
    }
}

#Preview {
    ChallengeDetailScreen(challenge: Challenge(name: "Text Challenge", date: Date(), notifications: true))
}
