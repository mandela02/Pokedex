//
//  DotDotDot.swift
//  Pokedex
//
//  Created by TriBQ on 18/10/2020.
//

import SwiftUI

struct DotDotDot: View {
    @State var isStart = false
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(alignment: .center, spacing: 10, content: {
                ForEach((0...8), id: \.self) { id in
                        Circle().fill(Color.black)
                            .opacity(isStart ? 1 : 0)
                            .transition(.opacity)
                            .animation(Animation.default.delay(Double(id)/2))
                }
        })
        .frame(height: 20, alignment: .center)
        .padding(.trailing, 20)
        .padding(.leading, 20)
        .onReceive(timer) { time in
            isStart.toggle()
        }
        .onAppear {
            isStart.toggle()
        }
    }
}

struct MovingDot: View {
    let timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
    @State var leftOffset: CGFloat = -100
    @State var rightOffset: CGFloat = 100
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: 1))
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: 1).delay(0.2))
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: 1).delay(0.4))
        }
        .onReceive(timer) { (_) in
            swap(&self.leftOffset, &self.rightOffset)
        }
    }
}
