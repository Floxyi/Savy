//
//  AccountView.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftData
import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel

    @State private var showConfirmationDialog = false
    @State private var isLoading = false

    @State private var isSignedIn = false

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack {
            if isSignedIn {
                VStack(alignment: .leading) {
                    Text(AuthService.shared.profile?.username ?? "Unkown")
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .foregroundStyle(currentScheme.font)
                    Text(AuthService.shared.supabaseAccount?.email ?? "error")
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .foregroundStyle(currentScheme.font)
                }

                Spacer()

                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 20, height: 20)
                    } else {
                        Text("Log Out")
                            .foregroundStyle(currentScheme.font)
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
                                Button("Cancel", role: .cancel) {}
                            }
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(currentScheme.font)
                            .fontWeight(.bold)
                            .font(.system(size: 16))
                    }
                }
                .padding(8)
                .frame(width: 130)
                .background(currentScheme.background)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.trailing, 4)
            } else {
                Spacer()

                HStack {
                    NavigationLink(destination: RegisterScreen(isSignedIn: $isSignedIn)) {
                        Text("Register")
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                            .foregroundStyle(currentScheme.font)
                            .frame(width: 100)
                            .padding(12)
                            .background(currentScheme.background)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Spacer()

                    Text("or")
                        .fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(currentScheme.font)

                    Spacer()

                    NavigationLink(destination: LoginScreen(isSignedIn: $isSignedIn)) {
                        Text("Login")
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                            .foregroundStyle(currentScheme.font)
                            .frame(width: 100)
                            .padding(12)
                            .background(currentScheme.background)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                Spacer()
            }
        }
        .frame(height: 44)
        .onAppear {
            Task {
                isSignedIn = AuthService.shared.isSignedIn()
            }
        }
    }

    func signOutButtonPressed() {
        isLoading = true
        Task {
            defer {
                isLoading = false
            }
            isSignedIn = try await AuthService.shared.signOut()
        }
    }
}

#Preview {
    SettingsTileView(image: "person.fill", text: "Account") {
        AccountView()
    }
    .padding()
    .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
