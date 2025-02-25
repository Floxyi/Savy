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
    @StateObject private var notificationService = NotificationService.shared
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel

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

                    SettingsTileView(image: "bell.fill", text: "Notifications") {
                        SettingsBarView(text: "Enable Notifications", toggle: $notificationService.notificationAllowed)
                            .onChange(of: notificationService.notificationAllowed) { _, newValue in
                                if newValue {
                                    notificationService.requestPermission()
                                } else {
                                    vm.showNotificationDisableAlert = true
                                }
                            }
                    }

                    VStack {
                        HStack {
                            Text("Made with")
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
                notificationService.checkPermissionStatus()
            }
            .alert("Notifications Disabled", isPresented: $notificationService.showSettingsAlert) {
                Button("Cancel", role: .cancel) {
                    notificationService.notificationAllowed = false
                }
                Button("Open Settings") {
                    notificationService.openSettings()
                }
            } message: {
                Text("To receive notifications, enable them in Settings.")
            }
            .alert("Notifications Enabled", isPresented: $vm.showNotificationDisableAlert) {
                Button("Cancel", role: .cancel) {
                    notificationService.notificationAllowed = true
                }
                Button("Open Settings") {
                    notificationService.openSettings()
                }
            } message: {
                Text("To stop reciving notifications, disable them in Settings.")
            }
        }
    }
}

#Preview {
    SettingsScreen()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
