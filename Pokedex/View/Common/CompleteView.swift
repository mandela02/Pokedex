//
//  CompleteView.swift
//  Pokedex
//
//  Created by TriBQ on 12/10/2020.
//

import SwiftUI

struct CompleteView: View {
    @State var showFirstStroke = false
    @State var showSecondStroke = false
    @State var showCheckMark = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                ZStack {
                    Circle()
                        .strokeBorder(lineWidth: showFirstStroke ? 5 : 50, antialiased: false)
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(showFirstStroke ? .green : .pink)
                        .rotation3DEffect(.degrees(showFirstStroke ? 0 : 360),
                                          axis: (x: 1, y: 1, z: 1))
                    
                    Circle()
                        .strokeBorder(lineWidth: showSecondStroke ? 5 : 50, antialiased: false)
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(showSecondStroke ? .green : .pink)
                        .rotation3DEffect(.degrees(showSecondStroke ? 0 : 360),
                                          axis: (x: -1, y: -1, z: -1))

                    Path { path in
                        path.move(to: CGPoint(x: 25, y: 45))
                        path.addLine(to: CGPoint(x: 25, y: 45))
                        path.addLine(to: CGPoint(x: 40, y: 60))
                        path.addLine(to: CGPoint(x: 70, y: 30))
                    }
                    .trim(from: 0, to: showCheckMark ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.green)
                    .offset(x: geometry.size.width/2 - 45, y: geometry.size.height/2 - 55)
                }
                .onDisappear {
                    toggle(isGone: true)
                }
                .onAppear {
                    toggle(isGone: false)
                }
                Text("This is the end of line, my man")
                    .font(.custom("Biotif-SemiBold", size: 20))
                    .foregroundColor(.red)
            }
        })
    }
    
    private func toggle(isGone: Bool) {
        withAnimation(Animation.easeInOut.delay(3)) {
            showCheckMark = isGone
        }
        withAnimation(Animation.easeInOut(duration: 2).delay(1)) {
            showSecondStroke = isGone
        }
        withAnimation(Animation.easeInOut(duration: 2).delay(1)) {
            showFirstStroke = isGone
        }
    }
}

struct CompleteView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteView()
    }
}
