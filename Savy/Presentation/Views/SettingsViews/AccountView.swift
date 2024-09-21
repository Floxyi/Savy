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
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        HStack {
            Spacer()
            
            if let appUser = appUser {
                Text("User is logged in: \(appUser.email ?? "error")")
                    .fontWeight(.bold)
                    .foregroundStyle(currentSchema.font)
                Text("Log Out")
                    .foregroundStyle(currentSchema.font)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .onTapGesture {
                        signOutButtonTapped()
                    }
            } else {
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
            }
            
            Spacer()
        }
        .frame(height: 44)
    }
    
    func signOutButtonTapped() {
        Task {
            do {
                self.appUser = try await AuthManager.shared.signOut()
                self.appUser = appUser
            }
        }
    }
}

#Preview {
    SettingsTileView(image: "person.fill", text: "Account") {
        AccountView(appUser: .constant(.init(uid: "1234", email: nil)))
    }
    .padding()
    .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
