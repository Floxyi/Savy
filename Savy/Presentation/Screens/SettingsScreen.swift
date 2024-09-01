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
    
    @State private var selectedMode: ColorSchemaMode = .light

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HeaderView(title: "Settings")
            
            Spacer()
            
            Picker("Color Mode", selection: $selectedMode) {
                Text("Light").tag(ColorSchemaMode.light)
                Text("Dark").tag(ColorSchemaMode.dark)
                Text("Colored Light").tag(ColorSchemaMode.coloredLight)
                Text("Colored Dark").tag(ColorSchemaMode.coloredDark)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedMode) {
                withAnimation {
                    updateSchemaForSelectedMode()
                }
            }
            
            if selectedMode == .coloredLight || selectedMode == .coloredDark {
                GradientSliderView(value: Binding(
                    get: { self.colorManagerVM.colorManager.hue },
                    set: { newValue in
                        self.colorManagerVM.colorManager.hue = newValue
                        self.updateSchemaForSelectedMode()
                    }
                ), range: 0...360)
                .padding()
            }
            Spacer()
        }
        .padding()
        .background(currentSchema.background)
        .onAppear {
            selectedMode = currentSchema.mode
        }
    }

    private func updateSchemaForSelectedMode() {
        switch selectedMode {
            case .light:
                colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.lightMode())
            case .dark:
                colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.darkMode())
            case .coloredLight:
                colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.coloredLightMode(hue: colorManagerVM.colorManager.hue))
            case .coloredDark:
                colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.coloredDarkMode(hue: colorManagerVM.colorManager.hue))
        }
    }
}

#Preview {
    SettingsScreen()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
