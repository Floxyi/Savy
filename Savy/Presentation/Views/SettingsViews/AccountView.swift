//
//  AccountView.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftData
import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    @EnvironmentObject private var tabBarManager: TabBarManager
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        HStack {
            if let appUser = appUser {
                Text("You are logged in: \(appUser.email ?? "error")")
                    .fontWeight(.bold)
                    .foregroundStyle(currentSchema.font)
                
                Spacer()
                
                HStack {
                    Text("Log Out")
                        .foregroundStyle(currentSchema.font)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .onTapGesture {
                            signOutButtonTapped()
                        }
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(currentSchema.font)
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                }
                .padding(8)
                .background(currentSchema.background)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.trailing, 4)
            } else {
                Spacer()
                
                HStack {
                    NavigationLink(destination: RegisterScreen(appUser: $appUser)) {
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
                    
                    NavigationLink(destination: LoginScreen(appUser: $appUser)) {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundStyle(currentSchema.font)
                            .frame(width: 80)
                            .padding(12)
                            .background(currentSchema.background)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                
                Spacer()
            }
            
        }
        .frame(height: 44)
        .onAppear(perform: {
            tabBarManager.show()
        })
    }
    
    func signOutButtonTapped() {
        Task {
            do {
                try await AuthManager.shared.signOut()
                self.appUser = nil
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var dummyUser: AppUser? = AppUser(uid: "123", email: "preview@example.com")
        
        var body: some View {
            SettingsTileView(image: "person.fill", text: "Account") {
                AccountView(appUser: $dummyUser)
            }
        }
    }
    
    return PreviewWrapper()
        .padding()
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
        .environmentObject(TabBarManager())
}
