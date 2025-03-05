//
//  SecondView.swift
//  Savy
//
//  Created by Nadine Schatz on 25.02.25.
//

import Foundation
import SwiftData
import SwiftUI

struct SecondView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel

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

        let minDate = statsServiceVM.statsService.entries.first?.date ?? Date()
        let maxDate = Date()

        let currentScheme = colorServiceVM.colorService.currentScheme
        let moneySavedStatsEntries: Bool = statsService.entries.first(where: { $0.type == StatsType.money_saved }) != nil

        ZStack {
            VStack(alignment: .leading) {
                HeaderView(title: String(localized: "Challenges"))
                ScrollView(.vertical, showsIndicators: false) {
                    if !moneySavedStatsEntries {
                        VStack {
                            Text("There are no stats yet! \nStart creating challenges to see your progress.")
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
                                    Text("Total challenges completed:")
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(currentScheme.font)
                                        .font(.system(size: 20))

                                    Text("\(statsService.totalChallengesCompleted().formatted())")
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
                                    Text("Challenges created:")
                                        .foregroundStyle(currentScheme.font)
                                        .font(.system(size: 16))
                                        .padding(.bottom, 4)

                                    HStack {
                                        VStack {
                                            Text("Last Month")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(NumberFormatterHelper.shared.formatCurrency(statsService.timeRangeChallengesStarted(startDate: statsService.calculateStartDateOfMonth(), endDate: Date())))")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }
                                        .padding(.leading, 32)

                                        Spacer()

                                        VStack {
                                            Text("Last Year")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(NumberFormatterHelper.shared.formatCurrency(statsService.timeRangeChallengesStarted(startDate: statsService.calculateStartDateOfYear(), endDate: Date())))")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }
                                        .padding(.trailing, 32)
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
                                    Text("\(NumberFormatterHelper.shared.formatCurrency(statsService.timeRangeChallengesStarted(startDate: startDate, endDate: endDate)))")
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
                                    Text("Challenges completed:")
                                        .foregroundStyle(currentScheme.font)
                                        .font(.system(size: 16))
                                        .padding(.bottom, 4)

                                    HStack {
                                        VStack {
                                            Text("Last Month")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(NumberFormatterHelper.shared.formatCurrency(statsService.timeRangeChallengesCompleted(startDate: statsService.calculateStartDateOfMonth(), endDate: Date())))")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }
                                        .padding(.leading, 32)

                                        Spacer()

                                        VStack {
                                            Text("Last Year")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(NumberFormatterHelper.shared.formatCurrency(statsService.timeRangeChallengesCompleted(startDate: statsService.calculateStartDateOfYear(), endDate: Date())))")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }
                                        .padding(.trailing, 32)
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
                                    Text("\(NumberFormatterHelper.shared.formatCurrency(statsService.timeRangeChallengesCompleted(startDate: secondStartDate, endDate: secondEndDate)))")
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
                                    Text("Challenges deleted:")
                                        .foregroundStyle(currentScheme.font)
                                        .font(.system(size: 16))
                                        .padding(.bottom, 4)

                                    HStack {
                                        VStack {
                                            Text("Last Month")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(NumberFormatterHelper.shared.formatCurrency(statsService.timeRangeChallengesDeleted(startDate: statsService.calculateStartDateOfMonth(), endDate: Date())))")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }
                                        .padding(.leading, 32)

                                        Spacer()

                                        VStack {
                                            Text("Last Year")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 12))

                                            Text("\(NumberFormatterHelper.shared.formatCurrency(statsService.timeRangeChallengesDeleted(startDate: statsService.calculateStartDateOfYear(), endDate: Date())))")
                                                .foregroundStyle(currentScheme.font)
                                                .font(.system(size: 28))
                                                .fontWeight(.bold)
                                        }
                                        .padding(.trailing, 32)
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
                                    Text("\(NumberFormatterHelper.shared.formatCurrency(statsService.timeRangeChallengesDeleted(startDate: secondStartDate, endDate: secondEndDate)))")
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

    return SecondView()
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}

#Preview("Empty") {
    SecondView()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
        .environmentObject(StatsServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: StatsService.self))))
}
