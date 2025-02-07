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

    @State private var statsType: StatsType = .money_saved
    @State private var startDate: Date = .init()
    @State private var endDate: Date = .init()

    @State private var showDatePicker = false
    @State private var isPickingStartDate = true
    @State private var scrollToEnd = false

    let minDate = StatsTracker.shared.entries.first?.date ?? Date()
    let maxDate = Date()

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme
        let moneySavedStatsEntries: Bool = StatsTracker.shared.entries.first(where: { $0.type == .money_saved }) != nil
        let challengesStartedStatsEntries: Bool = StatsTracker.shared.entries.first(where: { $0.type == .challenged_started }) != nil
        let challengesCompletedStatsEntries: Bool = StatsTracker.shared.entries.first(where: { $0.type == .challenged_completed }) != nil

        HeaderView(title: "Personal Stats")

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
                            Text("\(StatsTracker.shared.entries.first?.date.formatted(.dateTime.year().month().day()) ?? "")")
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
                                    Text("\(StatsTracker.shared.totalMoneySaved()) €")
                                        .foregroundStyle(currentScheme.font)
                                }

                                HStack {
                                    Text("Challenges started:")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                    Text("\(StatsTracker.shared.totalChallengesStarted())")
                                        .foregroundStyle(currentScheme.font)
                                }

                                HStack {
                                    Text("Challenges completed:")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                    Text("\(StatsTracker.shared.totalChallengesCompleted())")
                                        .foregroundStyle(currentScheme.font)
                                }
                                if StatsTracker.shared.allTimePunctuality() == nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentScheme.font)
                                            .fontWeight(.bold)
                                        Text("Not available")
                                            .foregroundStyle(currentScheme.font)
                                    }
                                }
                                if StatsTracker.shared.allTimePunctuality() != nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentScheme.font)
                                            .fontWeight(.bold)
                                        Text("\(StatsTracker.shared.allTimePunctuality() ?? 0) %")
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
                                    Text("\(StatsTracker.shared.timeRangeMoneySaved(startDate: startDate, endDate: endDate)) €")
                                        .foregroundStyle(currentScheme.font)
                                }

                                HStack {
                                    Text("Saving count:")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                    Text("\(StatsTracker.shared.timeRangeSavingCount(startDate: startDate, endDate: endDate))")
                                        .foregroundStyle(currentScheme.font)
                                }

                                if StatsTracker.shared.timeRangePunctuality(startDate: startDate, endDate: endDate) == nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentScheme.font)
                                            .fontWeight(.bold)
                                        Text("Not available")
                                            .foregroundStyle(currentScheme.font)
                                    }
                                }
                                if StatsTracker.shared.timeRangePunctuality(startDate: startDate, endDate: endDate) != nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentScheme.font)
                                            .fontWeight(.bold)
                                        Text("\(StatsTracker.shared.allTimePunctuality() ?? 0) %")
                                            .foregroundStyle(currentScheme.font)
                                    }
                                }

                                HStack {
                                    Text("Average saved per day:")
                                        .foregroundStyle(currentScheme.font)
                                        .fontWeight(.bold)
                                    Text(String(format: "%.2f", StatsTracker.shared.averageSavedTimeRange(startDate: startDate, endDate: endDate)))
                                        .foregroundStyle(currentScheme.font)
                                    Text("€")
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
    StatsTracker.shared.addChallengeCompletedStatsEntry(challengeId: UUID())
    StatsTracker.shared.addMoneySavedStatsEntry(savingId: UUID(), amount: 20, date: Date())
    StatsTracker.shared.addMoneySavedStatsEntry(savingId: UUID(), amount: 50, date: Date())
    StatsTracker.shared.addMoneySavedStatsEntry(savingId: UUID(), amount: 20, date: Date())
    StatsTracker.shared.addChallengeStartedStatsEntry(challengeId: UUID())
    StatsTracker.shared.addChallengeStartedStatsEntry(challengeId: UUID())

    return PersonalStatsView()
        .padding()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}

#Preview("Empty") {
    PersonalStatsView()
        .padding()
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}
