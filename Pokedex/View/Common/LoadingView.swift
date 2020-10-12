//
//  LoadingView.swift
//  Pokedex
//
//  Created by TriBQ on 12/10/2020.
//

import SwiftUI

struct LoadingView: View {
    @State private var isSpining = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            Text("Loading")
                .foregroundColor(.red)
                .shadow(color: .red, radius: 5, x: 1, y: 1)
            
            Circle().stroke(lineWidth: 5)
                .frame(width: 150, height: 150)
                .foregroundColor(.gray)
            
            Circle().stroke(lineWidth: 5)
                .trim(from: 0, to: 1/8)
                .stroke(style: StrokeStyle(lineWidth: 5,
                                           lineCap: .round,
                                           lineJoin: .round))
                .frame(width: 150, height: 150)
                .foregroundColor(.red)
                .overlay(Circle()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.red)
                            .offset(x: 0, y: 75))
                .shadow(color: .red, radius: 5, x: 1, y: 1)
                .offset()
                .rotationEffect(.degrees(isSpining ? 360 : 0))
                .onAppear {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        isSpining.toggle()
                    }
                }
        }
    }
}
