//
//  TabBarManager.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftUI

class TabBarManager: ObservableObject {
    @Published var isOn: Bool = true

    func hide() {
        isOn = false
    }
    
    func show() {
        isOn = true
    }
}
