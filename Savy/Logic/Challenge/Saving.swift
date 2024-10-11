//
//  Saving.swift
//  Savy
//
//  Created by Florian Winkler on 01.09.24.
//

import Foundation
import SwiftData

@Model
final class Saving {
    private(set) var id: UUID
    private(set) var amount: Int
    private(set) var date: Date
    private(set) var done: Bool
    
    init(amount: Int, date: Date) {
        self.id = UUID()
        self.amount = amount
        self.date = date
        self.done = false
    }
    
    func toggleDone() {
        done.toggle()
    }
    
    func setAmount(amount: Int) {
        self.amount = amount
    }
}
