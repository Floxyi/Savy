//
//  ThirdView.swift
//  Savy
//
//  Created by Nadine Schatz on 25.02.25.
//

import Foundation
import SwiftData
import SwiftUI

struct ThirdView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel

    @State private var startDate: Date = .init()
    @State private var endDate: Date = .init()
    @State private var secondStartDate: Date = .init()
    @State private var secondEndDate: Date = .init()

    @State private var showDatePicker = false
    @State private var isPickingStartDate = true
    @State private var showSecondDatePicker = false
    @State private var isPickingSecondStartDate = true
    @State private var scrollToEnd = false

    var body: some View {
        let statsService = statsServiceVM.statsService
        let challengeService = challengeServiceVM.challengeService

        let minDate = statsServiceVM.statsService.entries.first?.date ?? Date()
        let maxDate = Date()

        let currentScheme = colorServiceVM.colorService.currentScheme
        let hasPunctualityStats: Bool = statsService.entries.first(where: { $0.type == StatsType.challenge_started }) != nil

        ZStack {
            VStack(alignment: .center) {
                HeaderView(title: String(localized: "Reliability"))
                ScrollView(.vertical, showsIndicators: false) {
                    if !hasPunctualityStats {
                        VStack {
                            Text("There are no stats yet! \nStart by creating challenges to see your progress.")
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
                    } else {
                        ScrollViewReader { scrollViewProxy in
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack {
                                    Text("Total reliability:")
                                        .foregroundStyle(currentScheme.font)
                                        .font(.system(size: 20))

                                    Text("\(statsService.allTimePunctuality() ?? 0)%")
                                        .foregroundStyle(currentScheme.font)
                                        .font(.system(size: 44))
                                        .fontWeight(.bold)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(currentScheme.bar)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.bottom, 24)

                                VStack {
                                    Text("Reliability:")
                                        .foregroundStyle(currentScheme.font)
                                        .font(.system(size: 16))
                                        .padding(.bottom, 4)

                                    HStack {
                                        VStack {
                                            Text("Last Week")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(statsService.timeRangePunctuality(startDate: statsService.calculateStartDateOfWeek(), endDate: Date()) ?? 0)%")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }

                                        Spacer()

                                        VStack {
                                            Text("Last Month")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(statsService.timeRangePunctuality(startDate: statsService.calculateStartDateOfMonth(), endDate: Date()) ?? 0)%")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }

                                        Spacer()

                                        VStack {
                                            Text("Last Year")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(statsService.timeRangePunctuality(startDate: statsService.calculateStartDateOfYear(), endDate: Date()) ?? 0)%")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .padding(.bottom, 12)

                                    HStack {
                                        Button(action: {
                                            isPickingStartDate = true
                                            showDatePicker.toggle()
                                            scrollToEnd = true
                                        }) {
                                            HStack {
                                                Text("\(DateFormatterHelper.shared.formatDate(startDate))")
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
                                                Text("\(DateFormatterHelper.shared.formatDate(endDate))")
                                                    .font(.system(size: 16))
                                                    .padding(.trailing, -6)
                                                Image(systemName: "chevron.down")
                                            }
                                            .foregroundStyle(currentScheme.font)
                                            .fontWeight(.bold)
                                            .font(.system(size: 14))
                                            .padding(.leading, -4)
                                        }
                                    }
                                    Text("\(statsService.timeRangePunctuality(startDate: startDate, endDate: endDate) ?? 0)%")
                                        .foregroundStyle(currentScheme.font)
                                        .font(.system(size: 28))
                                        .fontWeight(.bold)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(currentScheme.bar)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.bottom, 12)

                                VStack {
                                    Text("Late savings:")
                                        .foregroundStyle(currentScheme.font)
                                        .font(.system(size: 16))
                                        .padding(.bottom, 4)

                                    HStack {
                                        VStack {
                                            Text("Last Week")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(statsService.lateSavingsCountTimeRange(startDate: statsService.calculateStartDateOfWeek(), endDate: Date(), challengeService: challengeService))")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }

                                        Spacer()

                                        VStack {
                                            Text("Last Month")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(statsService.lateSavingsCountTimeRange(startDate: statsService.calculateStartDateOfMonth(), endDate: Date(), challengeService: challengeService))")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }

                                        Spacer()

                                        VStack {
                                            Text("Last Year")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(statsService.lateSavingsCountTimeRange(startDate: statsService.calculateStartDateOfYear(), endDate: Date(), challengeService: challengeService))")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .padding(.bottom, 12)

                                    HStack {
                                        Button(action: {
                                            isPickingSecondStartDate = true
                                            showSecondDatePicker.toggle()
                                            scrollToEnd = true
                                        }) {
                                            HStack {
                                                Text("\(DateFormatterHelper.shared.formatDate(secondStartDate))")
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
                                            isPickingSecondStartDate = false
                                            showSecondDatePicker.toggle()
                                            scrollToEnd = true
                                        }) {
                                            HStack {
                                                Text("\(DateFormatterHelper.shared.formatDate(secondEndDate))")
                                                    .font(.system(size: 16))
                                                    .padding(.trailing, -6)
                                                Image(systemName: "chevron.down")
                                            }
                                            .foregroundStyle(currentScheme.font)
                                            .fontWeight(.bold)
                                            .font(.system(size: 14))
                                            .padding(.leading, -4)
                                        }
                                    }
                                    Text("\(statsService.lateSavingsCountTimeRange(startDate: secondStartDate, endDate: secondEndDate, challengeService: challengeService))")
                                        .foregroundStyle(currentScheme.font)
                                        .font(.system(size: 28))
                                        .fontWeight(.bold)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(currentScheme.bar)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.bottom, 12)
                            }
                            .onChange(of: scrollToEnd) { _, _ in
                                withAnimation {
                                    scrollViewProxy.scrollTo(1, anchor: .bottom)
                                    scrollToEnd = false
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .padding(.top)

            if showDatePicker || showSecondDatePicker {
                DismissableStatsOverlay(bindings: [$showDatePicker, $showSecondDatePicker])
            }

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
                .onChange(of: startDate) { _, _ in
                    showDatePicker = false
                }
                .onChange(of: endDate) { _, _ in
                    showDatePicker = false
                }
                .id(1)
            }

            if showSecondDatePicker {
                DatePicker(
                    "Select Date",
                    selection: isPickingSecondStartDate ? $secondStartDate : $secondEndDate,
                    in: minDate ... maxDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .background(currentScheme.bar)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, 24)
                .padding()
                .shadow(radius: 5)
                .onChange(of: secondStartDate) { _, _ in
                    showSecondDatePicker = false
                }
                .onChange(of: secondEndDate) { _, _ in
                    showSecondDatePicker = false
                }
                .id(1)
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

    return ThirdView()
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}

#Preview("Empty") {
    ThirdView()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
        .environmentObject(StatsServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: StatsService.self))))
}
