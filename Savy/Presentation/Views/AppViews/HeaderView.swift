//
//  HeaderView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftData
import SwiftUI

struct HeaderView: View {
    var title: String
    var dismiss: (() -> Void)? = nil
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        ZStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .font(.custom("Shrikhand-Regular", size: 44))
                    .foregroundStyle(currentSchema.font)
            }
            
            if let dismiss = dismiss {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(currentSchema.font)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 4)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        HeaderView(title: "Challenge")
        Spacer()
        HeaderView(title: "Challenge", dismiss: {})
        Spacer()
    }
    .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
