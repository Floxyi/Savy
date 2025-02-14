//
//  SettingsScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct SettingsScreen: View {
    @StateObject private var vm: SettingsViewModel
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    init() {
        _vm = StateObject(wrappedValue: SettingsViewModel())
    }

    var body: some View {
        NavigationView {
            VStack {
                HeaderView(title: String(localized: "Settings"))

                ScrollView(.vertical, showsIndicators: false) {
                    SettingsTileView(image: "person.fill", text: String(localized: "Account")) {
                        AccountView()
                    }

                    SettingsTileView(image: "paintbrush.fill", text: String(localized: "Design")) {
                        SettingsBarView(text: String(localized: "Dark Mode"), toggle: $vm.toggledDarkMode)
                            .onChange(of: vm.toggledDarkMode) { _, _ in
                                vm.onToggleModeChanged()
                            }
                        SettingsBarView(text: String(localized: "Color Mode"), toggle: $vm.toggledColorMode) {
                            if vm.toggledColorMode {
                                GradientSliderView(value: Binding(
                                    get: { colorServiceVM.colorService.hue },
                                    set: { newValue in
                                        colorServiceVM.colorService.hue = newValue
                                        vm.updateSchemaForSelectedMode()
                                    }
                                ), range: 0 ... 360)
                            }
                        }
                        .onChange(of: vm.toggledColorMode) { _, _ in
                            vm.onToggleModeChanged()
                        }
                    }

                    VStack {
                        HStack {
                            Text("Made with love")
                                .foregroundStyle(colorServiceVM.colorService.currentScheme.accent1)
                            Text("❤️")
                                .opacity(0.5)
                        }
                        Text("Version 1.0")
                            .foregroundStyle(colorServiceVM.colorService.currentScheme.accent1)
                    }
                    .padding(.bottom, 12)
                }
                Spacer()
            }
            .padding()
            .padding(.bottom, 80)
            .background(vm.currentScheme.background)
            .onAppear {
                TabBarManager.shared.show()
                vm.setColorService(colorServiceVM)
            }
        }
    }
}

#Preview {
    SettingsScreen()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
