//
//  SavingStats.swift
//  Savy
//
//  Created by Nadine Schatz on 11.10.24.
//

import Foundation
import SwiftData

/// A model representing statistics for a specific saving.
///
/// This class is used to track the details of a saving, including its expected date
/// and amount, in relation to the associated challenge or savings goal.
///
/// - `savingId`: A unique identifier for the saving.
/// - `amount`: The amount of money to be saved in this entry.
/// - `expectedDate`: The expected date by which the saving should be completed.
@Model
class SavingStats {
    /// The unique identifier for the saving.
    var savingId: UUID

    /// The amount of money to be saved in this entry.
    var amount: Int

    /// The expected date by which the saving should be completed.
    var expectedDate: Date

    /// Initializes a new instance of `SavingStats` with the given details.
    ///
    /// - Parameters:
    ///   - savingId: The unique identifier for the saving.
    ///   - amount: The amount of money to be saved.
    ///   - expectedDate: The expected date for the saving to be completed.
    init(savingId: UUID, amount: Int, expectedDate: Date) {
        self.savingId = savingId
        self.amount = amount
        self.expectedDate = Calendar.current.startOfDay(for: expectedDate)
    }
}
