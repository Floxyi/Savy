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
    @EnvironmentObject private var tabBarManager: TabBarManager
    
    @State private var selectedMode: ColorSchemaMode = .light
    @State private var toggledDarkMode: Bool = false
    @State private var toggledColorMode: Bool = false
    @State private var toggledNotifications: Bool = false
    @State private var toggledEachNotification: Bool = false
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        NavigationView {
            VStack {
                HeaderView(title: "Settings")
                
                ScrollView(.vertical, showsIndicators: false) {
                    SettingsTileView(image: "person.fill", text: "Account") {
                        AccountView(appUser: $appUser)
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
                                    get: { self.colorManagerVM.colorManager.hue },
                                    set: { newValue in
                                        self.colorManagerVM.colorManager.hue = newValue
                                        self.updateSchemaForSelectedMode()
                                    }
                                ), range: 0...360)
                            }
                        }
                        .onChange(of: toggledColorMode) {
                            withAnimation {
                                updateSchemaForSelectedMode()
                            }
                        }
                    }
                    
                    SettingsTileView(image: "bell.fill", text: "Notifications") {
                        SettingsBarView(text: "Enable Notifications", toggle: $toggledNotifications)
                        if toggledNotifications {
                            SettingsBarView(text: "Enable for each Challenge", toggle: $toggledEachNotification)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .padding(.bottom, 80)
            .background(currentSchema.background)
            .onAppear {
                selectedMode = currentSchema.mode
                toggledDarkMode = currentSchema.mode == .dark || currentSchema.mode == .coloredDark
                toggledColorMode = currentSchema.mode == .coloredLight || currentSchema.mode == .coloredDark
                
                Task {
                    self.appUser = try await AuthManager.shared.getCurrentSession()
                }
            }
        }
    }
    
    private func updateSchemaForSelectedMode() {
        if toggledDarkMode && !toggledColorMode {
            colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.darkMode())
        }
        
        if !toggledDarkMode && !toggledColorMode {
            colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.lightMode())
        }
        
        if !toggledDarkMode && toggledColorMode {
            colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.coloredLightMode(hue: colorManagerVM.colorManager.hue))
        }
        
        if toggledDarkMode && toggledColorMode {
            colorManagerVM.colorManager.updateSchema(schema: ColorSchemes.coloredDarkMode(hue: colorManagerVM.colorManager.hue))
        }
    }
}

#Preview("Logged In") {
    struct PreviewWrapper: View {
        @State private var dummyUser: AppUser? = AppUser(uid: "123", email: "preview@example.com")
        
        var body: some View {
            SettingsScreen(appUser: $dummyUser)
        }
    }
    
    return PreviewWrapper()
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
        .environmentObject(TabBarManager())
}

#Preview("Logged Out") {
    struct PreviewWrapper: View {
        @State private var dummyUser: AppUser? = nil
        
        var body: some View {
            SettingsScreen(appUser: $dummyUser)
        }
    }
    
    return PreviewWrapper()
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
        .environmentObject(TabBarManager())
}
