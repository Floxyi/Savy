//
//  SettingsScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct SettingsScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var colorManagers: [ColorManager]
    @State private var selectedMode: ColorSchemesEnum = .light
    
    private var colorManager: ColorManager {
        if let existingManager = colorManagers.first {
            if colorManagers.count > 1 {
                for manager in colorManagers.dropFirst() {
                    modelContext.delete(manager)
                }
            }
            return existingManager
        } else {
            let newManager = ColorManager(hue: 180, currentSchema: ColorSchemes.lightMode())
            modelContext.insert(newManager)
            return newManager
        }
    }
    
    var body: some View {
        VStack {
            HeaderView(title: "Settings")
            
            Spacer()
            
            Picker("Color Mode", selection: $selectedMode) {
                Text("Light").tag(ColorSchemesEnum.light)
                Text("Dark").tag(ColorSchemesEnum.dark)
                Text("Colored Light").tag(ColorSchemesEnum.coloredLight)
                Text("Colored Dark").tag(ColorSchemesEnum.coloredDark)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedMode) {
                withAnimation {
                    updateSchemaForSelectedMode()
                }
            }
            
            if selectedMode == .coloredLight || selectedMode == .coloredDark {
                Slider(value: Binding(
                    get: { self.colorManager.hue },
                    set: { newValue in
                        self.colorManager.hue = newValue
                        self.updateSchemaForSelectedMode()
                    }
                ), in: 0...360, step: 1) {
                    Text("Hue")
                }
                .padding()
            }
            
            Text("Hello, SwiftUI!")
                .background(colorManager.currentSchema.background)
            
            Spacer()
        }
        .onAppear {
            selectedMode = colorManager.currentSchema.mode
        }
    }
    
    private func updateSchemaForSelectedMode() {
        switch selectedMode {
            case .light:
                colorManager.updateSchema(schema: ColorSchemes.lightMode())
            case .dark:
                colorManager.updateSchema(schema: ColorSchemes.darkMode())
            case .coloredLight:
                colorManager.updateSchema(schema: ColorSchemes.coloredLightMode(hue: colorManager.hue))
            case .coloredDark:
                colorManager.updateSchema(schema: ColorSchemes.coloredDarkMode(hue: colorManager.hue))
        }
    }
}

#Preview {
    SettingsScreen()
        .modelContainer(for: [ColorManager.self])
}
