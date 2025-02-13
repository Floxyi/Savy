//
//  LeaderboardView.swift
//  Savy
//
//  Created by Florian Winkler on 14.10.24.
//

import SwiftData
import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    @State private var profiles: [ProfileWithSavings] = []
    @State private var isLoading = true

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        VStack {
            HeaderView(title: String(localized: "Leaderboard"))

            if isLoading {
                ProgressView()
            } else {
                if profiles.isEmpty {
                    emptyStateView(currentSchema: currentScheme)
                } else {
                    topProfilesView(currentSchema: currentScheme)
                    remainingProfilesView(currentSchema: currentScheme)
                }
            }
        }
        .background(currentScheme.background)
        .task {
            do {
                let fetchedProfiles = try await ProfileService.shared.getAllProfilesWithSavings()
                profiles = fetchedProfiles.sorted { $0.savings.amount > $1.savings.amount }
            } catch {}
            isLoading = false
        }
    }

    private func emptyStateView(currentSchema: ColorScheme) -> some View {
        VStack {
            Spacer()
            Text("There are not enough users yet...")
                .font(.system(size: 16, weight: .black))
                .foregroundColor(currentSchema.font)
            Spacer()
        }
    }

    private func topProfilesView(currentSchema: ColorScheme) -> some View {
        Group {
            if profiles.count >= 3 {
                HStack(alignment: .bottom) {
                    profileView(profile: profiles[1], rank: 2, currentSchema: currentSchema)
                    crownProfileView(profile: profiles[0], rank: 1, currentSchema: currentSchema)
                    profileView(profile: profiles[2], rank: 3, currentSchema: currentSchema)
                }
            }
        }
    }

    private func remainingProfilesView(currentSchema: ColorScheme) -> some View {
        Group {
            if profiles.count > 3 {
                ScrollView {
                    ForEach(0 ..< profiles.dropFirst(3).count, id: \.self) { index in
                        let profile = profiles[index + 3]
                        let profileId = AuthService.shared.accountUUID
                        let isCurrentUser = profile.id == profileId
                        HStack {
                            Text("\(index + 4).")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(currentSchema.font)
                            Text("\(profile.username)")
                                .font(.system(size: 18, weight: isCurrentUser ? .black : .medium))
                                .foregroundColor(currentSchema.font)
                            if isCurrentUser {
                                Text("(You)")
                                    .font(.system(size: 18))
                                    .foregroundColor(currentSchema.font)
                            }
                            Spacer()
                            Text("\(profile.savings.amount) $")
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

    private func profileView(profile: ProfileWithSavings, rank: Int, currentSchema: ColorScheme) -> some View {
        VStack {
            Text("\(profile.savings.amount) $")
                .font(.system(size: 20, weight: .black))
                .foregroundColor(currentSchema.font)
                .padding(1)
            Text("\(rank). \(profile.username)")
                .font(.system(size: 18, weight: profile.id == AuthService.shared.accountUUID ? .black : .regular))
                .foregroundColor(currentSchema.font)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 12)
        .padding(.top, 16)
        .frame(width: 110)
        .background(currentSchema.bar)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func crownProfileView(profile: ProfileWithSavings, rank: Int, currentSchema: ColorScheme) -> some View {
        VStack {
            Image(systemName: "crown.fill")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(currentSchema.font)
            VStack {
                Text("\(profile.savings.amount) $")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(currentSchema.font)
                    .padding(.top, 2)
                    .padding(.bottom, 4)
                Text("\(rank). \(profile.username)")
                    .font(.system(size: 22, weight: profile.id == AuthService.shared.accountUUID ? .black : .regular))
                    .foregroundColor(currentSchema.font)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.bottom, 12)
        .padding(.top, 12)
        .frame(width: 110)
        .background(currentSchema.bar)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    LeaderboardView()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
