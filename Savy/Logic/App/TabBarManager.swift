//
//  TabBarManager.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftUI

class TabBarManager: ObservableObject {
    static var shared = TabBarManager()

    @Published var selectedTab: Tab = .challenges
    @Published private(set) var isShown: Bool = true

    func hide() {
        isShown = false
    }

    func show() {
        isShown = true
    }

    func switchTab(tab: Tab) {
        selectedTab = tab
    }
}
