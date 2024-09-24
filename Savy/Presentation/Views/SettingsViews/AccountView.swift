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
    
    @State private var showConfirmationDialog = false
    @State private var isLoading = false
    
    @Binding var appUser: AppUser?
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        HStack {
            if let appUser = appUser {
                VStack(alignment: .leading) {
                    Text("You are logged in:")
                        .font(.system(size: 14))
                        .foregroundStyle(currentSchema.font)
                    Text(appUser.email ?? "error")
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .foregroundStyle(currentSchema.font)
                }
                
                Spacer()
                
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 20, height: 20)
                    } else {
                        Text("Log Out")
                            .foregroundStyle(currentSchema.font)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .padding(.leading, 4)
                            .onTapGesture {
                                showConfirmationDialog = true
                            }
                            .confirmationDialog("Are you sure you want to log out?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                                Button("Log Out", role: .destructive) {
                                    signOutButtonTapped()
                                }
                                Button("Cancel", role: .cancel) { }
                            }
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(currentSchema.font)
                            .fontWeight(.bold)
                            .font(.system(size: 16))
                    }
                }
                .padding(8)
                .frame(width: 110)
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
    }
    
    func signOutButtonTapped() {
        isLoading = true
        
        Task {
            defer {
                isLoading = false
            }
            
            do {
                try await AuthManager.shared.signOut()
                self.appUser = nil
            }
        }
    }
}

#Preview("Logged In") {
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
}

#Preview("Logged Out") {
    struct PreviewWrapper: View {
        @State private var dummyUser: AppUser? = nil
        
        var body: some View {
            SettingsTileView(image: "person.fill", text: "Account") {
                AccountView(appUser: $dummyUser)
            }
        }
    }
    
    return PreviewWrapper()
        .padding()
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
