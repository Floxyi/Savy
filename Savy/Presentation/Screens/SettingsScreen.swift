//
//  SettingsScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    @State private var selectedMode: ColorSchemeMode = .light
    @State private var toggledDarkMode: Bool = false
    @State private var toggledColorMode: Bool = false

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        NavigationView {
            VStack {
                HeaderView(title: "Settings")

                ScrollView(.vertical, showsIndicators: false) {
                    SettingsTileView(image: "person.fill", text: "Account") {
                        AccountView()
                    }

                    SettingsTileView(image: "paintbrush.fill", text: "Design") {
                        SettingsBarView(text: "Theme", toggle: $toggledDarkMode)
                            .onChange(of: toggledDarkMode) {
                                withAnimation {
                                    updateSchemaForSelectedMode()
                                }
                            }
                        SettingsBarView(text: "Color Mode", toggle: $toggledColorMode) {
                            if toggledColorMode {
                                GradientSliderView(value: Binding(
                                    get: { colorServiceVM.colorService.hue },
                                    set: { newValue in
                                        colorServiceVM.colorService.hue = newValue
                                        updateSchemaForSelectedMode()
                                    }
                                ), range: 0 ... 360)
                            }
                        }
                        .onChange(of: toggledColorMode) {
                            withAnimation {
                                updateSchemaForSelectedMode()
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .padding(.bottom, 80)
            .background(currentScheme.background)
            .onAppear {
                TabBarManager.shared.show()
                selectedMode = currentScheme.mode
                toggledDarkMode = currentScheme.mode == .dark || currentScheme.mode == .coloredDark
                toggledColorMode = currentScheme.mode == .coloredLight || currentScheme.mode == .coloredDark
            }
        }
    }

    private func updateSchemaForSelectedMode() {
        if toggledDarkMode, !toggledColorMode {
            colorServiceVM.colorService.updateScheme(schema: ColorSchemes.darkMode())
        }

        if !toggledDarkMode, !toggledColorMode {
            colorServiceVM.colorService.updateScheme(schema: ColorSchemes.lightMode())
        }

        if !toggledDarkMode, toggledColorMode {
            colorServiceVM.colorService.updateScheme(schema: ColorSchemes.coloredLightMode(hue: colorServiceVM.colorService.hue))
        }

        if toggledDarkMode, toggledColorMode {
            colorServiceVM.colorService.updateScheme(schema: ColorSchemes.coloredDarkMode(hue: colorServiceVM.colorService.hue))
        }
    }
}

#Preview {
    SettingsScreen()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
