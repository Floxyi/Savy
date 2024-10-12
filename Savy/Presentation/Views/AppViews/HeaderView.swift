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
    var size: CGFloat = 44
    var dismiss: (() -> Void)? = nil
    var actionView: AnyView? = nil
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        ZStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .font(.custom("Shrikhand-Regular", size: size))
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
                    .padding(.leading, 16)
                    .padding(.bottom, 4)
                    Spacer()
                }
            }
            
            if let actionView = actionView {
                HStack {
                    Spacer()
                    actionView
                        .padding(.trailing, 16)
                        .padding(.bottom, 4)
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
        HeaderView(title: "Challenge", dismiss: {}, actionView: AnyView(
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.gray)
        ))
        Spacer()
    }
    .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
