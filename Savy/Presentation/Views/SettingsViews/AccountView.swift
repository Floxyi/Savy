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

    @State private var isSignedIn = false

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        HStack {
            if isSignedIn {
                VStack(alignment: .leading) {
                    Text(AuthManager.shared.profile?.username ?? "Unkown")
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .foregroundStyle(currentSchema.font)
                    Text(AuthManager.shared.supabaseAccount?.email ?? "error")
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
                                signOutButtonPressed()
                            }
                            Button("Cancel", role: .cancel) {
                            }
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
                    NavigationLink(destination: RegisterScreen(isSignedIn: $isSignedIn)) {
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

                    NavigationLink(destination: LoginScreen(isSignedIn: $isSignedIn)) {
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
        .onAppear {
            Task {
                isSignedIn = AuthManager.shared.isSignedIn()
            }
        }
    }

    func signOutButtonPressed() {
        isLoading = true
        Task {
            defer {
                isLoading = false
            }
            isSignedIn = try await AuthManager.shared.signOut()
        }
    }
}

#Preview {
    SettingsTileView(image: "person.fill", text: "Account") {
        AccountView()
    }
    .padding()
    .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
