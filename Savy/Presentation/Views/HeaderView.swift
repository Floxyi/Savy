//
//  HeaderView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftUI

struct HeaderView: View {
    var title: String
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
                .font(.custom("Shrikhand-Regular", size: 36))
                .foregroundStyle(colorManagerVM.colorManager.currentSchema.font)
        }
    }
}
