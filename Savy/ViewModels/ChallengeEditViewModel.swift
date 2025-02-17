//
//  ChallengeEditViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

/// ViewModel for managing the state and actions related to editing a challenge.
class ChallengeEditViewModel: ObservableObject {
    /// The icon associated with the challenge.
    @Published var icon: String?

    /// The name of the challenge.
    @Published var name: String = ""

    /// The target amount for the challenge.
    @Published var amount: Int = 0

    /// The saving strategy for the challenge.
    @Published var strategy: SavingStrategy = .Weekly

    /// The saving calculation method for the challenge.
    @Published var calculation: SavingCalculation = .Date

    /// The cycle amount for the challenge, used in some calculation methods.
    @Published var cycleAmount: Int?

    /// The start date of the challenge.
    @Published var startDate: Date = .init() { didSet { updateEndDate() } }

    /// The end date of the challenge.
    @Published var endDate: Date = .init()

    /// Visibility of the start date picker.
    @Published var isStartDatePickerVisible = false

    /// Visibility of the end date picker.
    @Published var isEndDatePickerVisible = false

    /// Visibility of the icon picker.
    @Published var isIconPickerVisible = false

    /// The challenge object associated with this view model.
    var challenge: Challenge

    /// Initializes the `ChallengeEditViewModel` with a given challenge and loads its data.
    ///
    /// - Parameter challenge: The `Challenge` object to be edited.
    init(challenge: Challenge) {
        self.challenge = challenge
        loadChallengeData()
    }

    /// Loads the data from the `challenge` into the view model's properties.
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

    /// Updates the `endDate` based on the `strategy` and `startDate` values.
    func updateEndDate() {
        let minEndDate = Calendar.current.date(byAdding: strategy.calendarComponent, value: strategy.increment, to: startDate) ?? startDate
        endDate = endDate.compare(minEndDate) == .orderedAscending ? minEndDate : endDate
    }

    /// Validates the inputs to ensure they are valid for creating or editing a challenge.
    ///
    /// - Returns: `true` if the inputs are valid, otherwise `false`.
    func isValid() -> Bool {
        name != "" && amount != 0 && (calculation == .Amount ? cycleAmount != nil : true)
    }

    /// Calculates the end date based on the amount, using the challenge's configuration.
    ///
    /// - Returns: A string representing the calculated end date.
    func calculateEndDateByAmount() -> String {
        let calculatedDate = challenge.challengeConfiguration.calculateEndDateByAmount(challenge: challenge, startDate: challenge.challengeConfiguration.startDate)
        return calculatedDate.formatted(.dateTime.day().month().year())
    }

    /// Converts the current view model's properties into a `ChallengeConfiguration` object.
    ///
    /// - Returns: A `ChallengeConfiguration` object representing the current challenge data.
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

    /// Updates the challenge by saving the current data to the `ChallengeService`.
    ///
    /// - Parameter challengeService: The `ChallengeService` used to update the challenge.
    func updateChallenge(challengeService: ChallengeService) {
        let id = challenge.id
        let challengeConfiguration = getChallengeConfiguration()
        challengeService.updateChallenge(id: id, challengeConfiguration: challengeConfiguration)
    }
}
