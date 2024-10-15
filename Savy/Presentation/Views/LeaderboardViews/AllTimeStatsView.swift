//
//  AllTimeStatsView.swift
//  Savy
//
//  Created by Nadine Schatz on 13.10.24.
//

import SwiftUI
import SwiftData

struct AllTimeStatsView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    @State private var statsType: StatsType = .money_saved
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    @State private var showDatePicker = false
    @State private var isPickingStartDate = true
    @State private var scrollToEnd = false
    
    let minDate = StatsTracker.shared.entries.first?.date ?? Date()
    let maxDate = Date()
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        let moneySavedStatsEntries: Bool = StatsTracker.shared.entries.first(where: { $0.type == .money_saved }) != nil
        let challengesStartedStatsEntries: Bool = StatsTracker.shared.entries.first(where: { $0.type == .challenged_started }) != nil
        let challengesCompletedStatsEntries: Bool = StatsTracker.shared.entries.first(where: { $0.type == .challenged_completed }) != nil
        
        HeaderView(title: "Personal Stats")

        if !moneySavedStatsEntries && !challengesStartedStatsEntries && !challengesCompletedStatsEntries {
            VStack() {
                Text("There are no stats yet! Start saving money to see your progress.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(currentSchema.font)
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                    .padding(.bottom, 12)
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(currentSchema.font)
                    .font(.system(size: 44))
            }
            .padding(12)
            .background(currentSchema.bar)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.bottom, 24)
        }
        
        if moneySavedStatsEntries || challengesStartedStatsEntries || challengesCompletedStatsEntries {
            ScrollViewReader { scrollViewProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("All time stats")
                                .foregroundStyle(currentSchema.font)
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Spacer()
                            Text("\(StatsTracker.shared.entries.first(where: { $0.type == .money_saved })?.date.formatted(.dateTime.year().month().day()) ?? "")")
                                .foregroundStyle(currentSchema.font)
                            Image(systemName: "calendar")
                                .foregroundStyle(currentSchema.font)
                                .fontWeight(.bold)
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Total money saved:")
                                        .foregroundStyle(currentSchema.font)
                                        .fontWeight(.bold)
                                    Text("\(StatsTracker.shared.totalMoneySaved()) €")
                                        .foregroundStyle(currentSchema.font)
                                }
                                
                                HStack {
                                    Text("Challenges started:")
                                        .foregroundStyle(currentSchema.font)
                                        .fontWeight(.bold)
                                    Text("\(StatsTracker.shared.totalChallengesStarted())")
                                        .foregroundStyle(currentSchema.font)
                                }
                                
                                HStack {
                                    Text("Challenges completed:")
                                        .foregroundStyle(currentSchema.font)
                                        .fontWeight(.bold)
                                    Text("\(StatsTracker.shared.totalChallengesCompleted())")
                                        .foregroundStyle(currentSchema.font)
                                }
                                if StatsTracker.shared.allTimePunctuality() == nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentSchema.font)
                                            .fontWeight(.bold)
                                        Text("Not available")
                                            .foregroundStyle(currentSchema.font)
                                    }
                                }
                                if StatsTracker.shared.allTimePunctuality() != nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentSchema.font)
                                            .fontWeight(.bold)
                                        Text("\(StatsTracker.shared.allTimePunctuality() ?? 0) %")
                                            .foregroundStyle(currentSchema.font)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 12)
                    }
                    .background(currentSchema.bar)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 24)
                    
                    VStack {
                        HStack {
                            StatsTypeSelector(selectedStatsType: $statsType)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 4)
                                .background(currentSchema.bar)
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
                                        .foregroundStyle(currentSchema.font)
                                        .fontWeight(.bold)
                                        .font(.system(size: 16))
                                        .padding(.trailing, -4)
                                    }
                                    
                                    Text(" - ")
                                        .foregroundStyle(currentSchema.font)
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
                                        .foregroundStyle(currentSchema.font)
                                        .fontWeight(.bold)
                                        .font(.system(size: 14))
                                        .padding(.leading, -4)
                                    }
                                    
                                    Spacer()
                                }
                                HStack {
                                    Text("Money saved:")
                                        .foregroundStyle(currentSchema.font)
                                        .fontWeight(.bold)
                                    Text("\(StatsTracker.shared.timeRangeMoneySaved(startDate: startDate, endDate: endDate)) €")
                                        .foregroundStyle(currentSchema.font)
                                }
                                
                                HStack {
                                    Text("Saving count:")
                                        .foregroundStyle(currentSchema.font)
                                        .fontWeight(.bold)
                                    Text("\(StatsTracker.shared.timeRangeSavingCount(startDate: startDate, endDate: endDate))")
                                        .foregroundStyle(currentSchema.font)
                                }
                                
                                if StatsTracker.shared.timeRangePunctuality(startDate: startDate, endDate: endDate) == nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentSchema.font)
                                            .fontWeight(.bold)
                                        Text("Not available")
                                            .foregroundStyle(currentSchema.font)
                                    }
                                }
                                if StatsTracker.shared.timeRangePunctuality(startDate: startDate, endDate: endDate) != nil {
                                    HStack {
                                        Text("Punctuality:")
                                            .foregroundStyle(currentSchema.font)
                                            .fontWeight(.bold)
                                        Text("\(StatsTracker.shared.allTimePunctuality() ?? 0) %")
                                            .foregroundStyle(currentSchema.font)
                                    }
                                }
                                
                                HStack {
                                    Text("Average saved per day:")
                                        .foregroundStyle(currentSchema.font)
                                        .fontWeight(.bold)
                                    Text(String(format: "%.2f", StatsTracker.shared.averageSavedTimeRange(startDate: startDate, endDate: endDate)))
                                        .foregroundStyle(currentSchema.font)
                                    Text("€")
                                        .foregroundStyle(currentSchema.font)
                                        .padding(.leading, -4)
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(currentSchema.bar)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            if showDatePicker {
                                DatePicker(
                                    "Select Date",
                                    selection: isPickingStartDate ? $startDate : $endDate,
                                    in: minDate...maxDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.graphical)
                                .background(currentSchema.bar)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.top, 24)
                                .padding(.bottom, 100)
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
    
    return AllTimeStatsView()
        .padding()
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}

#Preview("Empty") {
    AllTimeStatsView()
        .padding()
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
