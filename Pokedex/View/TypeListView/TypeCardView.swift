//
//  TypeCardView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct TappableTypeCardView: View {
    var type: PokemonType
    var size: (width: CGFloat, height: CGFloat)
    @State var show: Bool = false
    
    var body: some View {
        TapToPushView(show: $show) {
            TypeCardView(type: type, size: size)
        } destination: {
            PokemonsOfTypeListNavigationView(show: $show, type: type)
        }
    }
}

struct TypeCardView: View {
    var type: PokemonType
    var size: (width: CGFloat, height: CGFloat)
    
    @State var image: UIImage?
    var body: some View {
        ZStack {
            type.color.background
                .ignoresSafeArea()
                .blur(radius: 1)
            
            HStack {
                Spacer()
                Image("ic_pokeball")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white.opacity(0.3))
                    .frame(width: size.height,
                           height: size.height,
                           alignment: .bottomTrailing)
                    .offset(x: 5)
                    .blur(radius: 1)
                
            }
            
            Text(type.rawValue.uppercased())
                .font(Biotif.black(size: 15).font)
                .foregroundColor(.white)
                .frame(width: size.width, height: size.height)
        }
        .frame(width: size.width, height: size.height)
        .background(Color.clear)
        .cornerRadius(25)
        .transition(.opacity)
        .animation(.spring())
    }
}
