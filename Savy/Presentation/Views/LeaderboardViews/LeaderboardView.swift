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
    @State private var savingsArray: [(profile: Profile, amount: Int)] = []
    @State private var isLoading = true
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HeaderView(title: "Leaderboard")
            
            if isLoading {
                ProgressView()
            } else {
                if users.isEmpty {
                    Spacer()
                    Text("There are not enough users yet... :(")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(currentSchema.font)
                    Spacer()
                } else {
                    if savingsArray.count >= 3 {
                        HStack(alignment: .bottom) {
                            VStack {
                                Text("\(savingsArray[1].amount) €")
                                    .font(.system(size: 20, weight: .black))
                                    .foregroundColor(currentSchema.font)
                                    .padding(1)
                                Text("2. \(savingsArray[1].profile.username ?? "Unknown")")
                                    .font(.system(size: 18, weight: savingsArray[1].profile.id == StatsTracker.shared.accountUUID ? .black : .regular))
                                    .foregroundColor(currentSchema.font)
                                    .multilineTextAlignment(.center)
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
                                    Text("\(savingsArray[0].amount) €")
                                        .font(.system(size: 22, weight: .black))
                                        .foregroundColor(currentSchema.font)
                                        .padding(.top, 2)
                                        .padding(.bottom, 4)
                                    Text("1. \(savingsArray[0].profile.username ?? "Unknown")")
                                        .font(.system(size: 22, weight: savingsArray[0].profile.id == StatsTracker.shared.accountUUID ? .black : .regular))
                                        .foregroundColor(currentSchema.font)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.bottom, 12)
                            .padding(.top, 12)
                            .frame(width: 110)
                            .background(currentSchema.bar)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            VStack {
                                Text("\(savingsArray[2].amount) €")
                                    .font(.system(size: 16, weight: .black))
                                    .foregroundColor(currentSchema.font)
                                Text("3. \(savingsArray[2].profile.username ?? "Unknown")")
                                    .font(.system(size: 16, weight: savingsArray[2].profile.id == StatsTracker.shared.accountUUID ? .black : .regular))
                                    .foregroundColor(currentSchema.font)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.bottom, 12)
                            .padding(.top, 12)
                            .frame(width: 110)
                            .background(currentSchema.bar)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    if savingsArray.count > 3 {
                        ScrollView {
                            ForEach(0..<savingsArray.dropFirst(3).count, id: \.self) { index in
                                let user = savingsArray[index + 3]
                                let profileId = StatsTracker.shared.accountUUID
                                let isCurrentUser = user.profile.id == profileId
                                HStack {
                                    Text("\(index + 4).")
                                        .font(.system(size: 16, weight: .black))
                                        .foregroundColor(currentSchema.font)
                                    Text("\(user.profile.username ?? "Unknown")")
                                        .font(.system(size: 18, weight: isCurrentUser ? .black : .medium))
                                        .foregroundColor(currentSchema.font)
                                    if isCurrentUser {
                                        Text("(Du)")
                                            .font(.system(size: 18))
                                            .foregroundColor(currentSchema.font)
                                    }
                                    Spacer()
                                    Text("\(user.amount) €")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(currentSchema.font)
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 12)
                                .background(currentSchema.bar)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 40)
                    }
                }
            }
        }
        .background(currentSchema.background)
        .task {
            do {
                savingsArray.removeAll()
                users = try await AuthManager.shared.client.from("profiles").select().execute().value
                for user in users {
                    let amount = try await StatsTracker.shared.getSavingsAmountFromDatabase(id: user.id)
                    savingsArray.append((profile: user, amount: amount))
                }
                savingsArray.sort { $0.amount > $1.amount }
            } catch { }
            isLoading = false
        }
    }
}

#Preview {
    LeaderboardView()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
