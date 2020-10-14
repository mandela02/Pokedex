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
        Button {
            show = true
        } label: {
            TypeCardView(type: type, size: size)
                .background(NavigationLink(destination: TypePokemonListView(show: $show,
                                                                            type: type),
                                           isActive: $show) { EmptyView() })
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
                .ignoresSafeArea().saturation(5.0)
                .blur(radius: 1)
            
            Image("ic_pokeball")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(type.color.background.opacity(0.5))
                .frame(width: size.height * 4/5, height: size.height * 4/5, alignment: .bottomTrailing)
                .offset(x: size.width * 1/4, y: size.height * 1/3 )
                .blur(radius: 1)
            
            Text(type.rawValue.uppercased())
                .font(Biotif.black(size: 12).font)
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
