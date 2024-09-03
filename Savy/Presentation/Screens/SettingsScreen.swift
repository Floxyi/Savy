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
    @State private var toggledDarkMode: Bool = false
    @State private var toggledColorMode: Bool = false
    @State private var toggledNotifications: Bool = false
    @State private var toggledEachNotification: Bool = false
    
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

struct AccountView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    @State var isAuthenticated = false
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        HStack {
            Spacer()
            
            if !isAuthenticated {
                NavigationLink(destination: RegisterScreen()) {
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundStyle(currentSchema.font)
                        .frame(width: 80)
                        .padding(12)
                        .background(currentSchema.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Spacer()
                
                Text("or")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(currentSchema.font)
                
                Spacer()
                
                NavigationLink(destination: LoginScreen()) {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundStyle(currentSchema.font)
                        .frame(width: 80)
                        .padding(12)
                        .background(currentSchema.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else {
                Text("User is logged in.")
                    .fontWeight(.bold)
                    .foregroundStyle(currentSchema.font)
            }
            
            Spacer()
        }
        .frame(height: 44)
        .task {
            for await state in supabase.auth.authStateChanges {
                if [.signedIn,].contains(state.event) {
                    isAuthenticated = state.session != nil
                }
            }
        }
    }
}

#Preview {
    SettingsScreen()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
