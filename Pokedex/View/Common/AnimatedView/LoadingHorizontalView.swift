//
//  LoadingHorizontalView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/14/20.
//

import SwiftUI

struct LoadingHorizontalView: View {
    @State private var move = false
    let screenFrame = Color(.systemBackground)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let width = geometry.size.width - 100
                VStack {
                    ZStack {
                        Capsule()
                            .foregroundColor(Color.clear)
                            .frame(width: geometry.size.width, height: 6, alignment: .center)
                        Capsule()
                            .clipShape(Rectangle().offset(x: move ? 80 : -80))
                            .frame(width: 100, height: 6, alignment: .leading)
                            .foregroundColor(Color.red)
                            .offset(x: move ? width/3 : -width/3)
                            .animation(Animation.easeInOut(duration: 0.5).delay(0.2).repeatForever(autoreverses: true))
                            .onAppear {
                                move.toggle()
                            }
                        
                    }
                }
            }
        }
    }
}

struct LoadingHorizontalView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingHorizontalView()
    }
}
