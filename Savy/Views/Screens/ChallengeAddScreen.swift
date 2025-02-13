//
//  ChallengeAddScreen.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftData
import SwiftUI

struct ChallengeAddScreen: View {
    @Binding var showPopover: Bool
    @StateObject private var vm: ChallengeAddViewModel
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @EnvironmentObject private var challengeServiceVM: ChallengeServiceViewModel
    @EnvironmentObject private var statsServiceVM: StatsServiceViewModel

    init(showPopover: Binding<Bool>) {
        _showPopover = showPopover
        _vm = StateObject(wrappedValue: ChallengeAddViewModel())
    }

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme
        let challengeConfiguration = vm.getChallengeConfiguration()

        NavigationStack {
            ZStack {
                VStack {
                    IconPicker(selectedIcon: $vm.icon, isIconPickerVisible: $vm.isIconPickerVisible)

                    TextField("", text: $vm.name, prompt: Text(verbatim: String(localized: "Name"))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(currentScheme.font.opacity(0.4)))
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(CustomTextFieldStyle())
                        .onChange(of: vm.name) { _, newValue in
                            if newValue.count > 12 {
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

                    CalculationSelector(selectedCalculation: $vm.calculation)

                    if vm.calculation == .Date {
                        HStack {
                            DatePicker(
                                "",
                                selection: $vm.endDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(CustomDatePickerStyle(date: vm.endDate, text: String(localized: "End date"), isDatePickerVisible: $vm.isDatePickerVisible))
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
                                TextField("", value: $vm.cycleAmount, format: .number, prompt: Text("\(vm.strategy.localizedString) \(String(localized: "Amount"))")
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

                        Text("End date: \(challengeConfiguration.calculateEndDateByAmount(startDate: challengeConfiguration.startDate).formatted(.dateTime.day().month().year()))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(currentScheme.font)
                            .padding()
                    }

                    Spacer()
                    HStack {
                        Spacer()
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
                            onDoneAction: { vm.addChallenge(challengeService: challengeServiceVM.challengeService, statsService: statsServiceVM.statsService) }
                        )
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        ToolbarCancelButton(showPopover: $showPopover)
                    }
                }

                if vm.isDatePickerVisible || vm.isIconPickerVisible {
                    DismissableOverlay(bindings: [$vm.isDatePickerVisible, $vm.isIconPickerVisible])
                }

                if vm.isDatePickerVisible {
                    VStack {
                        CustomDatePickerOverlay(
                            date: $vm.endDate,
                            startDate: Calendar.current.date(
                                byAdding: vm.strategy == .Weekly ? .weekOfYear : .month,
                                value: 1,
                                to: Date()
                            ) ?? Date()
                        )

                        HStack {
                            Text("\(vm.strategy) \(String(localized: "Amount")): \(challengeConfiguration.calculateCycleAmount(amount: challengeConfiguration.amount, startDate: challengeConfiguration.startDate))$")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(currentScheme.font)
                                .padding(8)
                        }
                        .background(currentScheme.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 22)
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

    let colorServiceContainer = try! ModelContainer(for: ColorService.self)
    let challengeServiceContainer = try! ModelContainer(for: ChallengeService.self)

    return Spacer()
        .popover(isPresented: $showPopover) {
            ChallengeAddScreen(showPopover: $showPopover)
        }
        .environmentObject(ColorServiceViewModel(modelContext: colorServiceContainer.mainContext))
        .environmentObject(ChallengeServiceViewModel(modelContext: challengeServiceContainer.mainContext))
}
