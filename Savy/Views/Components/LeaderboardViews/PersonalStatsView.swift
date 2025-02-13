//
//  PersonalStatsView.swift
//  Savy
//
//  Created by Nadine Schatz on 13.10.24.
//

import SwiftData
import SwiftUI

struct PersonalStatsView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel

    @State private var statsType: StatsType = .money_saved
    @State private var startDate: Date = .init()
    @State private var endDate: Date = .init()

    @State private var showDatePicker = false
    @State private var isPickingStartDate = true
    @State private var scrollToEnd = false

    var body: some View {
        let statsService = statsServiceVM.statsService

        let minDate = statsServiceVM.statsService.entries.first?.date ?? Date()
        let maxDate = Date()

        let currentScheme = colorServiceVM.colorService.currentScheme
        let moneySavedStatsEntries: Bool = statsService.entries.first(where: { $0.type == StatsType.money_saved }) != nil
        let challengesStartedStatsEntries: Bool = statsService.entries.first(where: { $0.type == StatsType.challenge_started }) != nil
        let challengesCompletedStatsEntries: Bool = statsService.entries.first(where: { $0.type == StatsType.challenge_completed }) != nil

        HeaderView(title: String(localized: "Personal Stats"))

        if !moneySavedStatsEntries && !challengesStartedStatsEntries && !challengesCompletedStatsEntries {
            VStack {
                Text("There are no stats yet! \nStart saving money to see your progress.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(currentScheme.font)
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                    .padding(.bottom, 12)
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(currentScheme.font)
                    .font(.system(size: 44))
            }
            .padding(12)
            .background(currentScheme.bar)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.bottom, 24)
        }

        if moneySavedStatsEntries || challengesStartedStatsEntries || challengesCompletedStatsEntries {
            ScrollViewReader { scrollViewProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("All time stats")
                                .foregroundStyle(currentScheme.font)
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Spacer()
                            Text("\(statsService.entries.first?.date.formatted(.dateTime.year().month().day()) ?? "")")
                                .foregroundStyle(currentScheme.font)
                            Image(systemName: "calendar")
                                .foregroundStyle(currentScheme.font)
                                .fontWeight(.bold)
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Total money saved:")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                    Text("\(statsService.totalMoneySaved())$")
                                        .foregroundStyle(currentScheme.font)
                                }

                                HStack {
                                    Text("Challenges started:")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                    Text("\(statsService.totalChallengesStarted())")
                                        .foregroundStyle(currentScheme.font)
                                }

                                HStack {
                                    Text("Challenges completed:")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                    Text("\(statsService.totalChallengesCompleted())")
                                        .foregroundStyle(currentScheme.font)
                                }
                                if statsServiceVM.statsService.allTimePunctuality() == nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentScheme.font)
                                            .fontWeight(.bold)
                                        Text("Not available")
                                            .foregroundStyle(currentScheme.font)
                                    }
                                }
                                if statsService.allTimePunctuality() != nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentScheme.font)
                                            .fontWeight(.bold)
                                        Text("\(statsService.allTimePunctuality() ?? 0) %")
                                            .foregroundStyle(currentScheme.font)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 12)
                    }
                    .background(currentScheme.bar)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 24)

                    VStack {
                        HStack {
                            StatsTypeSelector(selectedStatsType: $statsType)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 4)
                                .background(currentScheme.bar)
                                .clipShape(RoundedRectangle(cornerRadius: 6))

                            Spacer()
                        }
                        .padding(.bottom, 10)

                        ZStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Button(action: {
                                        isPickingStartDate = true
                                        showDatePicker.toggle()
                                        scrollToEnd = true
                                    }) {
                                        HStack {
                                            Text("\(startDate.formatted(.dateTime.year().month().day()))")
                                                .font(.system(size: 16))
                                                .padding(.trailing, -6)
                                            Image(systemName: "chevron.down")
                                                .font(.system(size: 14))
                                        }
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                        .font(.system(size: 16))
                                        .padding(.trailing, -4)
                                    }

                                    Text(" - ")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))

                                    Button(action: {
                                        isPickingStartDate = false
                                        showDatePicker.toggle()
                                        scrollToEnd = true
                                    }) {
                                        HStack {
                                            Text("\(endDate.formatted(.dateTime.year().month().day()))")
                                                .font(.system(size: 16))
                                                .padding(.trailing, -6)
                                            Image(systemName: "chevron.down")
                                        }
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                        .font(.system(size: 14))
                                        .padding(.leading, -4)
                                    }

                                    Spacer()
                                }
                                HStack {
                                    Text("Money saved:")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                    Text("\(statsService.timeRangeMoneySaved(startDate: startDate, endDate: endDate))$")
                                        .foregroundStyle(currentScheme.font)
                                }

                                HStack {
                                    Text("Saving count:")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                    Text("\(statsService.timeRangeSavingCount(startDate: startDate, endDate: endDate))")
                                        .foregroundStyle(currentScheme.font)
                                }

                                if statsService.timeRangePunctuality(startDate: startDate, endDate: endDate) == nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentScheme.font)
                                            .fontWeight(.bold)
                                        Text("Not available")
                                            .foregroundStyle(currentScheme.font)
                                    }
                                }
                                if statsService.timeRangePunctuality(startDate: startDate, endDate: endDate) != nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentScheme.font)
                                            .fontWeight(.bold)
                                        Text("\(statsServiceVM.statsService.allTimePunctuality() ?? 0) %")
                                            .foregroundStyle(currentScheme.font)
                                    }
                                }

                                HStack {
                                    Text("Average saved per day:")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                    Text(String(format: "%.2f", statsService.averageSavedTimeRange(startDate: startDate, endDate: endDate)))
                                        .foregroundStyle(currentScheme.font)
                                    Text("$")
                                        .foregroundStyle(currentScheme.font)
                                        .padding(.leading, -4)
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(currentScheme.bar)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                            if showDatePicker {
                                DatePicker(
                                    "Select Date",
                                    selection: isPickingStartDate ? $startDate : $endDate,
                                    in: minDate ... maxDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.graphical)
                                .background(currentScheme.bar)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.top, 24)
                                .padding()
                                .shadow(radius: 5)
                                .onChange(of: startDate) {
                                    showDatePicker = false
                                }
                                .onChange(of: endDate) {
                                    showDatePicker = false
                                }
                                .id(1)
                            }
                        }
                    }
                }
                .onChange(of: scrollToEnd) {
                    withAnimation {
                        scrollViewProxy.scrollTo(1, anchor: .bottom)
                        scrollToEnd = false
                    }
                }
            }
        }
    }
}

#Preview("Filled") {
    let schema = Schema([ChallengeService.self, ColorService.self, StatsService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let colorServiceViewModel = ColorServiceViewModel(modelContext: context)
    let challengeServiceViewModel = ChallengeServiceViewModel(modelContext: context)
    let statsServiceViewModel = StatsServiceViewModel(modelContext: context)

    let statsService = statsServiceViewModel.statsService

    let challengeConfiguration = ChallengeConfiguration(
        icon: "homepod",
        name: "HomePod",
        amount: 300,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 12
    )
    challengeServiceViewModel.challengeService.addChallenge(challengeConfiguration: challengeConfiguration, statsService: statsService)

    statsService.addChallengeCompletedStatsEntry(challengeId: UUID())
    statsService.addMoneySavedStatsEntry(savingId: UUID(), amount: 20, date: Date())
    statsService.addMoneySavedStatsEntry(savingId: UUID(), amount: 50, date: Date())
    statsService.addMoneySavedStatsEntry(savingId: UUID(), amount: 20, date: Date())
    statsService.addChallengeStartedStatsEntry(challengeId: UUID())
    statsService.addChallengeStartedStatsEntry(challengeId: UUID())

    return PersonalStatsView()
        .padding()
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}

#Preview("Empty") {
    PersonalStatsView()
        .padding()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
