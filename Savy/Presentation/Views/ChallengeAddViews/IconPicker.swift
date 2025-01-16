//
//  IconPicker.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct IconPicker: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    @Binding var selectedIcon: String?
    @Binding var isIconPickerVisible: Bool

    public var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        VStack {
            if selectedIcon == nil {
                Text("Choose icon")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(currentSchema.font)
                    .multilineTextAlignment(.center)
            } else {
                Image(systemName: selectedIcon!)
                    .font(.system(size: 30))
                    .foregroundColor(currentSchema.font)
                    .frame(width: 50, height: 50)
                    .background(currentSchema.background)
                    .cornerRadius(10)
            }
        }
        .onTapGesture {
            isIconPickerVisible = true
        }
        .frame(width: 75, height: 75)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [5]))
                .foregroundColor(currentSchema.font)
        )
        .padding(.bottom, 16)
    }
}

struct IconPickerOverlay: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    @Binding var selectedIcon: String?
    @Binding var isIconPickerVisible: Bool

    let columns = Array(repeating: GridItem(.flexible()), count: 5)

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        VStack {
            Text("Pick an icon:")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(currentSchema.font)
                .padding(.top)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(iconPickerList, id: \.self) { iconName in
                        Image(systemName: iconName)
                            .font(.system(size: 30))
                            .foregroundColor(currentSchema.font)
                            .frame(width: 50, height: 50)
                            .background(currentSchema.background)
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedIcon = iconName
                                isIconPickerVisible = false
                            }
                    }
                }
                .padding()
            }
        }
        .frame(maxHeight: 500)
        .background(currentSchema.background)
        .cornerRadius(12)
        .padding(32)
        .onTapGesture {
            isIconPickerVisible.toggle()
        }
        .animation(.easeInOut, value: isIconPickerVisible)
    }
}
