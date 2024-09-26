//
//  ToolbarCancelButton.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct ToolbarCancelButton: View {
    @Binding var showPopover: Bool
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    public var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Button("Cancel") {
            showPopover = false
        }
        .font(.system(size: 16))
        .foregroundStyle(currentSchema.barIcons)
    }
}
