//
//  PokemonContainerHeaderView.swift
//  Pokedex
//
//  Created by TriBQ on 16/10/2020.
//

import SwiftUI

struct PokemonContainerHeaderView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PokemonContainerHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonContainerHeaderView()
    }
}


struct ButtonView: View {    
    @Binding var isShowing: Bool
    @Binding var isInExpandeMode: Bool
    var pokemon: Pokemon
    var namespace: Namespace.ID
    
    @State var isFavorite = false
    
    var body: some View {
        HStack{
            Button {
                withAnimation(.spring()){
                    isShowing = false
                }
            } label: {
                Image(systemName: ("arrow.uturn.left"))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.clear)
                    .clipShape(Circle())
            }
            .frame(width: 50, height: 50, alignment: .center)
            Spacer()
            if !isInExpandeMode {
                Text(pokemon.name.capitalized)
                    .font(Biotif.bold(size: 25).font)
                    .fontWeight(.bold)
                    .foregroundColor(pokemon.mainType.color.text)
                    .background(Color.clear)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: pokemon.name, in: namespace)
                Spacer()
            }
            AnimatedLikeButton(isFavorite: $isFavorite)
                .padding()
                .background(Color.clear)
                .clipShape(Circle())
                .frame(width: 50, height: 50, alignment: .center)
        }
        .padding(.top, UIDevice().hasNotch ? 44 : 8)
        .padding(.horizontal)
    }
}

struct NameView: View {
    var pokemon: Pokemon
    var namespace: Namespace.ID
    
    @Binding var opacity: Double
    
    var body: some View {
        HStack(alignment: .lastTextBaseline){
            Text(pokemon.name.capitalized)
                .font(Biotif.bold(size: 35).font)
                .fontWeight(.bold)
                .foregroundColor(pokemon.mainType.color.text)
                .background(Color.clear)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .matchedGeometryEffect(id: pokemon.name, in: namespace)
            Spacer()
            Text(String(format: "#%03d", pokemon.pokeId))
                .font(Biotif.bold(size: 20).font)
                .fontWeight(.bold)
                .foregroundColor(pokemon.mainType.color.text)
                .background(Color.clear)
                .frame(alignment: .topLeading)
                .lineLimit(1)
                .opacity(opacity)
        }
        .background(Color.clear)
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.horizontal)
    }
}

struct TypeView: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack(alignment: .center, spacing: 30, content: {
            ForEach(pokemon.types.map({$0.type})) { type in
                Text(type.name)
                    .frame(alignment: .leading)
                    .font(.system(size: 15))
                    .foregroundColor(pokemon.mainType.color.text)
                    .background(Rectangle()
                                    .fill(Color.white.opacity(0.5))
                                    .cornerRadius(10)
                                    .padding(EdgeInsets(top: -5, leading: -10, bottom: -5, trailing: -10)))
            }
            Spacer()
        })
        .padding(.leading, 40)
        .padding(.top, 5)
        .background(Color.clear)
    }
}
