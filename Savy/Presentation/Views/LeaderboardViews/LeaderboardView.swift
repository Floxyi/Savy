//
//  LeaderboardView.swift
//  Savy
//
//  Created by Florian Winkler on 14.10.24.
//

import SwiftUI
import SwiftData

struct LeaderboardView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    @State var users: [Profile] = []
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HeaderView(title: "Leaderboard")
            
            if users.isEmpty {
                ProgressView()
            }
            
            if !users.isEmpty {
                if users.count >= 3 {
                    HStack(alignment: .bottom) {
                        VStack {
                            VStack {
                                Text("\(users[1].id.description.prefix(3)) €")
                                    .font(.system(size: 20, weight: .black))
                                    .foregroundColor(currentSchema.font)
                                    .padding(1)
                                Text("2. \(users[1].username ?? "Unkown")")
                                    .font(.system(size: 18))
                                    .foregroundColor(currentSchema.font)
                            }
                        }
                        .padding(.bottom, 12)
                        .padding(.top, 16)
                        .frame(width: 110)
                        .background(currentSchema.bar)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(currentSchema.font)
                            VStack {
                                Text("\(users[0].id.description.prefix(3)) €")
                                    .font(.system(size: 22, weight: .black))
                                    .foregroundColor(currentSchema.font)
                                    .padding(.top, 2)
                                    .padding(.bottom, 4)
                                Text("1. \(users[0].username ?? "Unkown")")
                                    .font(.system(size: 22))
                                    .foregroundColor(currentSchema.font)
                            }
                        }
                        .padding(.bottom, 12)
                        .padding(.top, 12)
                        .frame(width: 110)
                        .background(currentSchema.bar)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack {
                            Text("\(users[2].id.description.prefix(3)) €")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(currentSchema.font)
                            Text("3. \(users[2].username ?? "Unkown")")
                                .font(.system(size: 16))
                                .foregroundColor(currentSchema.font)
                        }
                        .padding(.bottom, 12)
                        .padding(.top, 12)
                        .frame(width: 110)
                        .background(currentSchema.bar)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            
            if users.count > 3 {
                List(users) { user in
                    Text(user.username ?? "Unknown")
                    Spacer()
                    Text("\(user.id.description.prefix(3)) €")
                }
                .scrollContentBackground(.hidden)
            }
        }
        .background(currentSchema.background)
        .task {
            do {
                users = try await AuthManager.shared.client.from("profiles").select().execute().value
            } catch {
                dump(error)
            }
        }
    }
}

#Preview {
    LeaderboardView()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
