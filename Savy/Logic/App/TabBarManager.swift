//
//  TabBarManager.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftUI

class TabBarManager {
    static var shared = TabBarManager()
    
    private(set) var selectedTab: Tab = Tab.challenges
    private(set) var isShown: Bool = true
    
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
