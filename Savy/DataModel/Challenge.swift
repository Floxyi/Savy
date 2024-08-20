//
//  Challenge.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import Foundation
import SwiftData

@Model
final class Challenge {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
