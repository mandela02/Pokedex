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

struct DotDotDot_Previews: PreviewProvider {
    static var previews: some View {
        DotDotDot()
    }
}
