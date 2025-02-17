//
//  ChallengeAddViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

/// ViewModel for adding a new challenge.
class ChallengeAddViewModel: ObservableObject {
    /// The icon for the challenge.
    @Published var icon: String?

    /// The name of the challenge.
    @Published var name: String = ""

    /// The amount for the challenge.
    @Published var amount: Int?

    /// The strategy for the challenge (e.g., weekly, monthly).
    @Published var strategy: SavingStrategy = .Weekly

    /// The calculation method for the challenge (e.g., based on amount or date).
    @Published var calculation: SavingCalculation = .Date

    /// The cycle amount (used when calculation is based on amount).
    @Published var cycleAmount: Int?

    /// The start date of the challenge.
    @Published var startDate: Date { didSet { updateEndDate() } }

    /// The end date of the challenge.
    @Published var endDate: Date

    /// Boolean flag indicating if the start date picker is visible.
    @Published var isStartDatePickerVisible = false

    /// Boolean flag indicating if the end date picker is visible.
    @Published var isEndDatePickerVisible = false

    /// Boolean flag indicating if the icon picker is visible.
    @Published var isIconPickerVisible = false

    /// Initializes a new `ChallengeAddViewModel` with default start and end dates.
    init() {
        startDate = Date()
        endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
    }

    /// Updates the end date based on the selected start date and strategy.
    func updateEndDate() {
        let minEndDate = Calendar.current.date(byAdding: strategy.calendarComponent, value: strategy.increment, to: startDate) ?? startDate
        endDate = endDate.compare(minEndDate) == .orderedAscending ? minEndDate : endDate
    }

    /// Validates the fields for the challenge form.
    ///
    /// - Returns: `true` if all necessary fields are valid; otherwise `false`.
    func isValid() -> Bool {
        icon != nil && !name.isEmpty && amount != nil && (calculation == .Amount ? cycleAmount != nil : true)
    }

    /// Creates a `ChallengeConfiguration` object with the current values from the view model.
    ///
    /// - Returns: A new `ChallengeConfiguration` instance.
    func getChallengeConfiguration() -> ChallengeConfiguration {
        ChallengeConfiguration(
            icon: icon ?? "square.dashed",
            name: name,
            amount: amount ?? 0,
            startDate: startDate,
            endDate: endDate,
            strategy: strategy,
            calculation: calculation,
            cycleAmount: cycleAmount
        )
    }

    /// Adds a challenge using the given `ChallengeService` and `StatsService`.
    ///
    /// - Parameters:
    ///   - challengeService: The `ChallengeService` responsible for adding challenges.
    ///   - statsService: The `StatsService` used for tracking statistics.
    func addChallenge(challengeService: ChallengeService, statsService: StatsService) {
        let challengeConfiguration = getChallengeConfiguration()
        challengeService.addChallenge(challengeConfiguration: challengeConfiguration, statsService: statsService)
    }
}
