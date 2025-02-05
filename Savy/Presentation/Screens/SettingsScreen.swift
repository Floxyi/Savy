//
//  SettingsScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    @State private var selectedMode: ColorSchemeMode = .light
    @State private var toggledDarkMode: Bool = false
    @State private var toggledColorMode: Bool = false

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

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
                                    get: { colorManagerVM.colorManager.hue },
                                    set: { newValue in
                                        colorManagerVM.colorManager.hue = newValue
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
            .background(currentSchema.background)
            .onAppear {
                TabBarManager.shared.show()
                selectedMode = currentSchema.mode
                toggledDarkMode = currentSchema.mode == .dark || currentSchema.mode == .coloredDark
                toggledColorMode = currentSchema.mode == .coloredLight || currentSchema.mode == .coloredDark
            }
        }
    }

    private func updateSchemaForSelectedMode() {
        if toggledDarkMode, !toggledColorMode {
            colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.darkMode())
        }

        if !toggledDarkMode, !toggledColorMode {
            colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.lightMode())
        }

        if !toggledDarkMode, toggledColorMode {
            colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.coloredLightMode(hue: colorManagerVM.colorManager.hue))
        }

        if toggledDarkMode, toggledColorMode {
            colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.coloredDarkMode(hue: colorManagerVM.colorManager.hue))
        }
    }
}

#Preview {
    SettingsScreen()
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
