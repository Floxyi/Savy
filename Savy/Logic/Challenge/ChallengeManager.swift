//
//  ChallengeManager.swift
//  Savy
//
//  Created by Nadine Schatz on 11.10.24.
//

import Foundation

class ChallengeManager {
    static let shared = ChallengeManager()
    var challenges: [Challenge] = []
    
    init() {}
    
    func getChallengeById(id: UUID) -> Challenge? {
        for challenge in ChallengeManager.shared.challenges where challenge.id == id {
            return challenge
        }
        return nil
    }
    
    func addChallengeToChallenges(challengeConfiguration: ChallengeConfiguration) {
        ChallengeManager.shared.challenges.append(challengeConfiguration.createChallenge())
    }
}
