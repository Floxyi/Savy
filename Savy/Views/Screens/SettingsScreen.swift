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
                HeaderView(title: "Settings")

                ScrollView(.vertical, showsIndicators: false) {
                    SettingsTileView(image: "person.fill", text: "Account") {
                        AccountView()
                    }

                    SettingsTileView(image: "paintbrush.fill", text: "Design") {
                        SettingsBarView(text: "Theme", toggle: $vm.toggledDarkMode)
                            .onChange(of: vm.toggledDarkMode) { _, _ in
                                vm.onToggleModeChanged()
                            }
                        SettingsBarView(text: "Color Mode", toggle: $vm.toggledColorMode) {
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
