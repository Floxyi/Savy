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
    var id: UUID
    var amount: Int
    var expectedDate: Date
    
    init(id: UUID, amount: Int, expectedDate: Date) {
        self.id = id
        self.amount = amount
        self.expectedDate = expectedDate
    }
}
