//
//  SavingStats.swift
//  Savy
//
//  Created by Nadine Schatz on 11.10.24.
//

import Foundation
import SwiftData

@Model
class SavingStats {
    var savingId: UUID
    var amount: Int
    var expectedDate: Date
    
    init(savingId: UUID, amount: Int, expectedDate: Date) {
        self.savingId = savingId
        self.amount = amount
        self.expectedDate = Calendar.current.startOfDay(for: expectedDate)
    }
}
