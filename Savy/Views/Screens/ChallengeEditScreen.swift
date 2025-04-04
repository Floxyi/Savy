//
//  ChallengeEditScreen.swift
//  Savy
//
//  Created by Florian Winkler on 11.10.24.
//

import SwiftData
import SwiftUI

struct ChallengeEditScreen: View {
    @StateObject private var vm: ChallengeEditViewModel
    @Binding var showPopover: Bool
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel

    init(challenge: Challenge, showPopover: Binding<Bool>) {
        _vm = StateObject(wrappedValue: ChallengeEditViewModel(challenge: challenge))
        _showPopover = showPopover
    }

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme
        let challengeConfiguration = vm.getChallengeConfiguration()

        NavigationStack {
            ZStack {
                VStack {
                    ScrollView {
                        IconPicker(selectedIcon: $vm.icon, isIconPickerVisible: $vm.isIconPickerVisible)

                        TextField("", text: $vm.name, prompt: Text(verbatim: String(localized: "Name"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(currentScheme.font.opacity(0.4)))
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(CustomTextFieldStyle())
                            .onChange(of: vm.name) { _, newValue in
                                if newValue.count > 35 {
                                    vm.name = String(newValue.prefix(12))
                                }
                            }

                        HStack {
                            TextField("", value: $vm.amount, format: .number, prompt: Text(verbatim: String(localized: "Amount"))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(currentScheme.font.opacity(0.4)))
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.numberPad)
                            Text("$")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(currentScheme.font)
                                .padding(.trailing, 32)
                        }

                        HStack {
                            Text(String(localized: "Strategy"))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(currentScheme.font.opacity(0.4))
                                .padding(.leading, 8)

                            Spacer()

                            StrategySelector(selectedStrategy: $vm.strategy, onChangeAction: { vm.updateEndDate() })
                        }
                        .frame(height: 38)
                        .background(currentScheme.bar)
                        .cornerRadius(8)
                        .padding(.horizontal, 16)

                        HStack {
                            DatePicker("", selection: $vm.startDate, displayedComponents: [.date])
                                .datePickerStyle(CustomDatePickerStyle(date: vm.startDate, text: String(localized: "Start date"), isDatePickerVisible: $vm.isStartDatePickerVisible))
                        }
                        .padding(.horizontal, 8)
                        .frame(height: 38)
                        .background(currentScheme.bar)
                        .cornerRadius(8)
                        .padding(.top, 8)
                        .padding(.horizontal, 16)

                        CalculationSelector(selectedCalculation: $vm.calculation)

                        if vm.calculation == .Date {
                            HStack {
                                DatePicker("", selection: $vm.endDate, displayedComponents: [.date])
                                    .datePickerStyle(CustomDatePickerStyle(date: vm.endDate, text: String(localized: "End date"), isDatePickerVisible: $vm.isEndDatePickerVisible))
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 38)
                            .background(currentScheme.bar)
                            .cornerRadius(8)
                            .padding(.top, 8)
                            .padding(.horizontal, 24)

                            Text("\(vm.strategy.localizedString) \(String(localized: "Amount")): \(challengeConfiguration.calculateCycleAmount(amount: challengeConfiguration.amount, startDate: challengeConfiguration.startDate))$")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(currentScheme.font)
                                .padding()
                        }

                        if vm.calculation == .Amount {
                            VStack {
                                HStack {
                                    TextField("", value: $vm.cycleAmount, format: .number, prompt: Text(verbatim: "\(vm.strategy) Amount")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(currentScheme.font.opacity(0.4)))
                                        .textFieldStyle(CustomTextFieldStyle())
                                        .keyboardType(.numberPad)
                                    Text("$")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundStyle(currentScheme.font)
                                        .padding(.trailing, 32)
                                }
                            }
                            .frame(height: 38)
                            .padding(.top, 8)
                            .padding(.horizontal, 8)

                            Text("\(String(localized: "End date")): \(vm.calculateEndDateByAmount())")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(currentScheme.font)
                                .padding()
                        }

                        Spacer()
                        HStack {
                            Spacer()
                        }
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
                .padding()
                .background(currentScheme.background)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        ToolbarDoneButton(
                            showPopover: $showPopover,
                            title: String(localized: "Done"),
                            isValid: { vm.isValid() },
                            onDoneAction: { vm.updateChallenge(challengeService: challengeServiceVM.challengeService) }
                        )
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        ToolbarCancelButton(showPopover: $showPopover)
                    }
                }

                if vm.isStartDatePickerVisible || vm.isEndDatePickerVisible || vm.isIconPickerVisible {
                    DismissableOverlay(bindings: [$vm.isStartDatePickerVisible, $vm.isEndDatePickerVisible, $vm.isIconPickerVisible])
                }

                if vm.isStartDatePickerVisible {
                    CustomDatePickerOverlay(date: $vm.startDate, startDate: .constant(Date()))
                }

                if vm.isEndDatePickerVisible {
                    VStack {
                        CustomDatePickerOverlay(date: $vm.endDate, startDate: $vm.startDate)

                        HStack {
                            Text("\(vm.strategy.localizedString) \(String(localized: "Amount")): \(challengeConfiguration.calculateCycleAmount(amount: challengeConfiguration.amount, startDate: challengeConfiguration.startDate))$")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(currentScheme.font)
                                .padding(10)
                        }
                        .background(currentScheme.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 12)
                    }
                }

                if vm.isIconPickerVisible {
                    IconPickerOverlay(selectedIcon: $vm.icon, isIconPickerVisible: $vm.isIconPickerVisible)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var showPopover = true

    let schema = Schema([ChallengeService.self, ColorService.self, StatsService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let colorServiceViewModel = ColorServiceViewModel(modelContext: context)
    let challengeServiceViewModel = ChallengeServiceViewModel(modelContext: context)
    let statsServiceViewModel = StatsServiceViewModel(modelContext: context)

    let challengeConfiguration = ChallengeConfiguration(
        icon: "homepod",
        name: "HomePod",
        amount: 300,
        startDate: Date(),
        strategy: .Monthly,
        calculation: .Amount,
        cycleAmount: 12
    )
    challengeServiceViewModel.challengeService.addChallenge(challengeConfiguration: challengeConfiguration, statsService: statsServiceViewModel.statsService)

    return Spacer()
        .popover(isPresented: $showPopover) {
            ChallengeEditScreen(challenge: challengeServiceViewModel.challengeService.challenges.first!, showPopover: $showPopover)
        }
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
        .environmentObject(challengeServiceViewModel)
        .environmentObject(statsServiceViewModel)
}
