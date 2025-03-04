//
//  DataHelper.swift
//  Savy
//
//  Created by Florian Winkler on 04.03.25.
//

import Foundation

struct DataHelper {
    let challengeService: ChallengeService
    let statsService: StatsService

    init(challengeService: ChallengeService, statsService: StatsService) {
        self.challengeService = challengeService
        self.statsService = statsService
    }

    func loadData() {
        if !shouldInsertTestData() {
            return
        }

        let challengeConfiguration = ChallengeConfiguration(icon: "homepod", name: "HomePod", amount: 300, startDate: generateRandomPastDate(), strategy: .Monthly, calculation: .Amount, cycleAmount: 12)
        challengeService.addChallenge(challengeConfiguration: challengeConfiguration, statsService: statsService)

        for _ in 1 ... 20 {
            statsService.addChallengeCompletedStatsEntry(challengeId: UUID(), date: generateRandomPastDate())
            statsService.addChallengeStartedStatsEntry(challengeId: UUID(), date: generateRandomPastDate())
            statsService.addChallengeDeletedStatsEntry(date: generateRandomPastDate())
        }

        for _ in 1 ... 80 {
            let date = generateRandomPastDate()
            let addedDate = Bool.random() && generateRandomInteger(min: 1, max: 5) == 1 ? generateRandomPastDate() : date
            statsService.addMoneySavedStatsEntry(savingId: UUID(), amount: generateRandomInteger(min: 1, max: 100), date: date, addedDate: addedDate)
        }
    }

    private func generateRandomPastDate() -> Date {
        let calendar = Calendar.current
        let yearsAgo = generateRandomInteger(min: 0, max: 2)
        let randomDays = generateRandomInteger(min: 0, max: 365)

        if let randomStartDate = calendar.date(byAdding: .year, value: -yearsAgo, to: Date()),
           let finalStartDate = calendar.date(byAdding: .day, value: -randomDays, to: randomStartDate)
        {
            return finalStartDate
        }

        return Date()
    }

    private func generateRandomInteger(min: Int, max: Int) -> Int {
        Int.random(in: min ... max)
    }

    private func shouldInsertTestData() -> Bool {
        let key = "hasTestData"
        let launchedBefore = UserDefaults.standard.bool(forKey: key)

        if !launchedBefore {
            UserDefaults.standard.setValue(true, forKey: key)
            UserDefaults.standard.synchronize()
        }

        return !launchedBefore
    }
}
