//
//  SettingsViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var selectedMode: ColorSchemeMode = .light
    @Published var toggledDarkMode: Bool = false
    @Published var toggledColorMode: Bool = false
    @Published private(set) var currentScheme: ColorScheme
    @Published var showNotificationDisableAlert: Bool = false

    private var colorServiceVM: ColorServiceViewModel?

    init(colorServiceVM: ColorServiceViewModel? = nil) {
        self.colorServiceVM = colorServiceVM
        currentScheme = colorServiceVM?.colorService.currentScheme ?? ColorSchemes.lightMode()
        syncWithColorService()
    }

    func setColorService(_ colorServiceVM: ColorServiceViewModel) {
        self.colorServiceVM = colorServiceVM
        syncWithColorService()
    }

    private func syncWithColorService() {
        guard let colorService = colorServiceVM?.colorService else { return }
        selectedMode = colorService.currentScheme.mode
        toggledDarkMode = selectedMode == .dark || selectedMode == .coloredDark
        toggledColorMode = selectedMode == .coloredLight || selectedMode == .coloredDark
    }

    func updateSchemaForSelectedMode() {
        guard let colorService = colorServiceVM?.colorService else { return }

        let newScheme: ColorScheme = switch (toggledDarkMode, toggledColorMode) {
        case (true, false):
            ColorSchemes.darkMode()
        case (false, false):
            ColorSchemes.lightMode()
        case (false, true):
            ColorSchemes.coloredLightMode(hue: colorService.hue)
        case (true, true):
            ColorSchemes.coloredDarkMode(hue: colorService.hue)
        }

        colorService.updateScheme(schema: newScheme)
        currentScheme = newScheme
    }

    func onToggleModeChanged() {
        withAnimation {
            updateSchemaForSelectedMode()
        }
    }
}
