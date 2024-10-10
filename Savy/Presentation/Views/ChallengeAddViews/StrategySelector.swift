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
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    public var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Menu {
            ForEach(SavingStrategy.allCases, id: \.self) { strategy in
                Button(action: {
                    selectedStrategy = strategy
                    onChangeAction()
                }) {
                    Text(strategy.rawValue)
                }
            }
        } label: {
            HStack {
                Text(selectedStrategy.rawValue)
                    .font(.system(size: 16))
                    .foregroundColor(currentSchema.font)
                Image(systemName: "chevron.down")
                    .font(.system(size: 16))
                    .foregroundColor(currentSchema.font)
            }
            .padding(.horizontal, 8)
            .background(currentSchema.bar)
        }
    }
}
