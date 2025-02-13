//
//  StrategySelector.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct StrategySelector: View {
    @Binding var selectedStrategy: SavingStrategy
    let onChangeAction: () -> Void

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    public var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        Menu {
            ForEach(SavingStrategy.allCases, id: \.self) { strategy in
                Button(action: {
                    selectedStrategy = strategy
                    onChangeAction()
                }) {
                    Text(strategy.localizedString)
                }
            }
        } label: {
            HStack {
                Text(selectedStrategy.localizedString)
                    .font(.system(size: 16))
                    .foregroundColor(currentScheme.font)
                Image(systemName: "chevron.down")
                    .font(.system(size: 16))
                    .foregroundColor(currentScheme.font)
            }
            .padding(.horizontal, 8)
            .background(currentScheme.bar)
        }
    }
}
