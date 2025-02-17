//
//  SettingsViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

/// ViewModel for managing user settings, particularly related to color scheme preferences.
class SettingsViewModel: ObservableObject {
    /// The selected color scheme mode (light or dark).
    @Published var selectedMode: ColorSchemeMode = .light

    /// Boolean indicating whether dark mode is toggled.
    @Published var toggledDarkMode: Bool = false

    /// Boolean indicating whether color mode is toggled.
    @Published var toggledColorMode: Bool = false

    /// The current color scheme in use.
    @Published private(set) var currentScheme: ColorScheme

    /// Boolean indicating whether to show the notification disable alert.
    @Published var showNotificationDisableAlert: Bool = false

    /// The `ColorServiceViewModel` used to manage color schemes.
    private var colorServiceVM: ColorServiceViewModel?

    /// Initializes the `SettingsViewModel` with an optional `ColorServiceViewModel`.
    ///
    /// - Parameter colorServiceVM: An optional `ColorServiceViewModel` to manage color schemes.
    init(colorServiceVM: ColorServiceViewModel? = nil) {
        self.colorServiceVM = colorServiceVM
        currentScheme = colorServiceVM?.colorService.currentScheme ?? ColorSchemes.lightMode()
        syncWithColorService()
    }

    /// Sets the `ColorServiceViewModel` and syncs the current color scheme.
    ///
    /// - Parameter colorServiceVM: The `ColorServiceViewModel` to be used.
    func setColorService(_ colorServiceVM: ColorServiceViewModel) {
        self.colorServiceVM = colorServiceVM
        syncWithColorService()
    }

    /// Syncs the `SettingsViewModel` with the current color scheme from the `ColorService`.
    private func syncWithColorService() {
        guard let colorService = colorServiceVM?.colorService else { return }
        selectedMode = colorService.currentScheme.mode
        toggledDarkMode = selectedMode == .dark || selectedMode == .coloredDark
        toggledColorMode = selectedMode == .coloredLight || selectedMode == .coloredDark
    }

    /// Updates the color scheme based on the selected mode and toggles.
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

    /// Handles the toggle mode change by updating the scheme and applying the change with animation.
    func onToggleModeChanged() {
        withAnimation {
            updateSchemaForSelectedMode()
        }
    }
}
