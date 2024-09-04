//
//  GradientSliderView.swift
//  Savy
//
//  Created by Florian Winkler on 01.09.24.
//

import SwiftData
import SwiftUI

struct GradientSliderView: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    @State private var isDragging = false
    @FocusState var isInputActive: Bool
    
    private let gradientColors: [Color] = [.red, .yellow, .green, .cyan, .blue, .purple, .red]
    private let thumbSize: CGFloat = 28
    private let trackHeight: CGFloat = 8
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            HStack {
                Text(String(format: "%.0f", value))
                    .foregroundStyle(currentSchema.font)
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .padding(.horizontal, 4)
                    .frame(width: 38, alignment: .trailing)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: trackHeight / 2)
                            .fill(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing))
                            .frame(height: trackHeight)
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: thumbSize, height: thumbSize)
                            .shadow(radius: isDragging ? 4 : 2)
                            .offset(x: thumbPosition(in: geometry.size.width))
                            .gesture(dragGesture(in: geometry.size.width))
                    }
                }
                .frame(height: thumbSize)
                
                Text("360")
                    .foregroundStyle(currentSchema.font)
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .padding(.horizontal, 4)
            }
        }
    }
    
    private func thumbPosition(in width: CGFloat) -> CGFloat {
        let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return (width - thumbSize) * CGFloat(percent)
    }
    
    private func dragGesture(in width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { drag in
                isDragging = true
                let dragLocation = drag.location.x
                let percent = max(0, min(1, dragLocation / (width - thumbSize)))
                value = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percent)
            }
            .onEnded { _ in
                isDragging = false
            }
    }
}

#Preview {
    @State var value: Double = 0
    return GradientSliderView(value: $value, range: 0...360)
    .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}
