//
//  ChallengeManager.swift
//  Savy
//
//  Created by Nadine Schatz on 11.10.24.
//

import Foundation
import SwiftData

@Model
class ChallengeManager {
    static let shared = ChallengeManager()
    private(set) var challenges: [Challenge] = []
    
    init() {}
    
    func getChallengeById(id: UUID) -> Challenge? {
        return challenges.first(where: { $0.id == id })
    }
    
    func addChallenge(challengeConfiguration: ChallengeConfiguration) {
        let challenge = Challenge(challengeConfiguration: challengeConfiguration)
        StatsTracker.shared.addChallengeStartedStatsEntry(challengeId: challenge.id)
        challenges.append(challenge)
    }
    
    func removeChallenge(id: UUID) {
        let hasFinished = challenges.first(where: { $0.id == id })!.remainingAmount() == 0
        hasFinished ? StatsTracker.shared.addChallengeCompletedStatsEntry(challengeId: id) : StatsTracker.shared.deleteStatsEntry(challengeId: id)
        challenges.removeAll(where: { $0.id == id })
    }
    
    func removeAllChallenges() {
        challenges.removeAll()
    }
    
    func updateChallenge(id: UUID, challengeConfiguration: ChallengeConfiguration) {
        let challenge = challenges.first(where: { $0.id == id })!
        challenge.updateConfiguration(challengeConfiguration: challengeConfiguration)
        challenges.removeAll(where: { $0.id == id })
        challenges.append(challenge)
    }
    
    func sortChallenges() -> [Challenge] {
        let calendar = Calendar.current

        let sortedChallenges = challenges.sorted { (challenge1: Challenge, challenge2: Challenge) -> Bool in
            let nextSaving1 = challenge1.getNextSaving(at: 1)
            let nextSaving2 = challenge2.getNextSaving(at: 1)
            
            let dateComponents1 = DateComponents(
                year: calendar.component(.year, from: nextSaving1.date),
                month: calendar.component(.month, from: nextSaving1.date),
                day: calendar.component(.day, from: nextSaving1.date)
            )
            let dateComponents2 = DateComponents(
                year: calendar.component(.year, from: nextSaving2.date),
                month: calendar.component(.month, from: nextSaving2.date),
                day: calendar.component(.day, from: nextSaving2.date)
            )
            
            let date1 = calendar.date(from: dateComponents1) ?? Date()
            let date2 = calendar.date(from: dateComponents2) ?? Date()
            
            let remainingSavings1 = challenge1.remainingSavings()
            let remainingSavings2 = challenge2.remainingSavings()
            
            if remainingSavings1 == 0 && remainingSavings2 == 0 {
                return challenge1.challengeConfiguration.endDate < challenge2.challengeConfiguration.endDate
            }
            
            if remainingSavings1 == 0 { return false }
            if remainingSavings2 == 0 { return true }
            
            return date1 == date2 ? nextSaving1.amount < nextSaving2.amount : date1 < date2
        }
        
        return sortedChallenges
    }
}
