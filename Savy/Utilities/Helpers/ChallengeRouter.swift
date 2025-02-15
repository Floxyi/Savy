//
//  ChallengeRouter.swift
//  Savy
//
//  Created by Florian Winkler on 15.02.25.
//

import Foundation

class ChallengeRouter: ObservableObject {
    @Published var path = [String]()

    func navigateToChallenge(with challengeID: String) {
        path = [challengeID]
    }
}
