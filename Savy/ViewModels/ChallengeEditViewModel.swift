//
//  ChallengeEditViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

class ChallengeEditViewModel: ObservableObject {
    @Published var icon: String?
    @Published var name: String = ""
    @Published var amount: Int = 0
    @Published var strategy: SavingStrategy = .Weekly
    @Published var calculation: SavingCalculation = .Date
    @Published var cycleAmount: Int?
    @Published var startDate: Date = .init() { didSet { updateEndDate() } }
    @Published var endDate: Date = .init()

    @Published var isStartDatePickerVisible = false
    @Published var isEndDatePickerVisible = false
    @Published var isIconPickerVisible = false

    var challenge: Challenge

    init(challenge: Challenge) {
        self.challenge = challenge
        loadChallengeData()
    }

    private func loadChallengeData() {
        icon = challenge.challengeConfiguration.icon
        name = challenge.challengeConfiguration.name
        amount = challenge.challengeConfiguration.amount
        startDate = challenge.challengeConfiguration.startDate
        endDate = challenge.challengeConfiguration.endDate
        strategy = challenge.challengeConfiguration.strategy
        calculation = challenge.challengeConfiguration.calculation
        cycleAmount = challenge.challengeConfiguration.cycleAmount
    }

    func updateEndDate() {
        let minEndDate = Calendar.current.date(byAdding: strategy.calendarComponent, value: strategy.increment, to: startDate) ?? startDate
        endDate = endDate.compare(minEndDate) == .orderedAscending ? minEndDate : endDate
    }

    func isValid() -> Bool {
        name != "" && amount != 0 && (calculation == .Amount ? cycleAmount != nil : true)
    }

    func calculateEndDateByAmount() -> String {
        let calculatedDate = challenge.challengeConfiguration.calculateEndDateByAmount(challenge: challenge, startDate: challenge.challengeConfiguration.startDate)
        return calculatedDate.formatted(.dateTime.day().month().year())
    }

    func getChallengeConfiguration() -> ChallengeConfiguration {
        ChallengeConfiguration(
            icon: icon ?? "square.dashed",
            name: name,
            amount: amount,
            startDate: startDate,
            endDate: endDate,
            strategy: strategy,
            calculation: calculation,
            cycleAmount: cycleAmount
        )
    }

    func updateChallenge(challengeService: ChallengeService) {
        let id = challenge.id
        let challengeConfiguration = getChallengeConfiguration()
        challengeService.updateChallenge(id: id, challengeConfiguration: challengeConfiguration)
    }
}
