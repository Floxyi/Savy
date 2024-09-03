//
//  AccountView.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftUI

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
