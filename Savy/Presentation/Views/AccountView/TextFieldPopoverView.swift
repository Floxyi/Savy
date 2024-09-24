//
//  PopoverView.swift
//  Savy
//
//  Created by Florian Winkler on 23.09.24.
//


import SwiftUI

struct TextFieldPopoverView: View {
    @Binding var showPopup: Bool
    let isValid: Bool
    let error: Bool
    let text: String
    
    var body: some View {
        Group {
            if showPopup {
                VStack {
                    Text(text)
                        .foregroundColor(isValid ? .green : error ? .gray : .red)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding()
                        .padding(.trailing, 14)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .background(
                            SpeechBubbleShape()
                                .fill(Color.white)
                                .shadow(radius: 4)
                        )
                }
                .transition(.scale)
                .animation(.spring(), value: showPopup)
            }
        }
    }
}

struct SpeechBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let cornerRadius: CGFloat = 8
        let triangleHeight: CGFloat = 20
        let triangleWidth: CGFloat = 15
        
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.width - triangleWidth, height: rect.height), cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        path.move(to: CGPoint(x: rect.width - triangleWidth, y: rect.height / 2 - triangleHeight / 2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width - triangleWidth, y: rect.height / 2 + triangleHeight / 2))
        
        return path
    }
}
