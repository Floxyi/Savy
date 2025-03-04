//
//  LeaderboardScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct LeaderboardScreen: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @State var showsPersonalStats: Bool = false

    @State private var profiles: [ProfileWithSavings] = []
    @State private var isLoading = true

    init(profiles: [ProfileWithSavings] = [], isLoading: Bool = false) {
        _profiles = State(initialValue: profiles)
        _isLoading = State(initialValue: isLoading)
    }

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        VStack {
            HeaderView(title: String(localized: "Leaderboard"))

            if isLoading {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                if profiles.isEmpty {
                    HStack {
                        Spacer()
                        emptyStateView(currentSchema: currentScheme)
                        Spacer()
                    }
                } else {
                    VStack {
                        topProfilesView(currentSchema: currentScheme)
                        remainingProfilesView(currentSchema: currentScheme)
                    }
                    .refreshable {
                        await fetchData()
                    }
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

    private func fetchData() async {
        do {
            try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            let fetchedProfiles = try await ProfileService.shared.getAllProfilesWithSavings()
            profiles = fetchedProfiles.sorted { $0.savings.amount > $1.savings.amount }
        } catch {}
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
                    crownProfileView(profile: profiles[0], rank: 1, currentScheme: currentSchema)
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
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(currentSchema.font)
                            Text("\(profile.username)")
                                .font(.system(size: 14, weight: isCurrentUser ? .bold : .medium))
                                .foregroundColor(currentSchema.font)
                            if isCurrentUser {
                                Text("(You)")
                                    .font(.system(size: 12))
                                    .foregroundColor(currentSchema.font)
                            }
                            Spacer()
                            Text("$\(NumberFormatterHelper.shared.formatCurrency(profile.savings.amount))")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(currentSchema.font)
                        }
                        .padding(.horizontal, 12)
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
        let profileId = AuthService.shared.accountUUID
        let isCurrentUser = profile.id == profileId

        return VStack {
            Text("$\(NumberFormatterHelper.shared.formatCurrency(profile.savings.amount))")
                .font(.system(size: 16, weight: .black))
                .foregroundColor(currentSchema.font)
                .padding(1)
            Text("\(rank). \(profile.username)")
                .font(.system(size: 14, weight: profile.id == AuthService.shared.accountUUID ? .black : .regular))
                .foregroundColor(currentSchema.font)
                .multilineTextAlignment(.center)
            if isCurrentUser {
                Text("(You)")
                    .font(.system(size: 12))
                    .foregroundColor(currentSchema.font)
            }
        }
        .padding(.bottom, 12)
        .padding(.top, 16)
        .frame(width: 110)
        .background(currentSchema.bar)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func crownProfileView(profile: ProfileWithSavings, rank: Int, currentScheme: ColorScheme) -> some View {
        let profileId = AuthService.shared.accountUUID
        let isCurrentUser = profile.id == profileId

        return VStack {
            Image(systemName: "crown.fill")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(currentScheme.font)
            VStack {
                Text("$\(NumberFormatterHelper.shared.formatCurrency(profile.savings.amount))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(currentScheme.font)
                    .padding(.top, 2)
                    .padding(.bottom, 4)
                Text("\(rank). \(profile.username)")
                    .font(.system(size: 14, weight: profile.id == AuthService.shared.accountUUID ? .black : .regular))
                    .foregroundColor(currentScheme.font)
                    .multilineTextAlignment(.center)
                if isCurrentUser {
                    Text("(You)")
                        .font(.system(size: 12))
                        .foregroundColor(currentScheme.font)
                }
            }
        }
        .padding(.bottom, 12)
        .padding(.top, 12)
        .padding(.horizontal, 4)
        .frame(width: 110)
        .background(currentScheme.bar)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Empty Leaderboard") {
    let schema = Schema([ColorService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    return LeaderboardScreen(profiles: [], isLoading: false)
        .modelContainer(container)
        .environmentObject(ColorServiceViewModel(modelContext: context))
}

#Preview("Filled Leaderboard") {
    let schema = Schema([ColorService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let mockProfiles = [
        ProfileWithSavings(id: UUID(), username: "Alice", savings: Savings(profileId: UUID(), amount: 1500)),
        ProfileWithSavings(id: UUID(), username: "Bob", savings: Savings(profileId: UUID(), amount: 300)),
        ProfileWithSavings(id: UUID(), username: "Charlie", savings: Savings(profileId: UUID(), amount: 200)),
        ProfileWithSavings(id: UUID(), username: "Anderson", savings: Savings(profileId: UUID(), amount: 100)),
        ProfileWithSavings(id: UUID(), username: "Alice", savings: Savings(profileId: UUID(), amount: 100)),
        ProfileWithSavings(id: UUID(), username: "Ken", savings: Savings(profileId: UUID(), amount: 100)),
    ]

    return LeaderboardScreen(profiles: mockProfiles, isLoading: false)
        .modelContainer(container)
        .environmentObject(ColorServiceViewModel(modelContext: context))
}
