//
//  PokedexCardView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

struct PokedexCardView: View {
    //@ObservedObject var updater: PokemonUpdater
    var pokemon: Pokemon
    var size: (width: CGFloat, height: CGFloat)
    
    @State var viewAppear: Bool = false

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center,
                                    vertical: .center),
               content: {
                if pokemon.mainType == .non {
                    Color.white
                        .blur(radius: 1)
                } else {
                    pokemon.mainType.color.background
                        .blur(radius: 1)
                }
                
                Image("ic_pokeball")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(pokemon.mainType == .non ? pokemon.mainType.color.background : Color.white.opacity(0.3))
                    .frame(width: size.height * 4/5, height: size.height * 4/5, alignment: .bottomTrailing)
                    .offset(x: size.width * 1/4, y: size.height * 1/3 )
                    .blur(radius: 1)
                
                VStack {
                    Spacer()
                    if viewAppear {
                        DownloadedImageView(withURL: pokemon.sprites.other?.artwork.front ?? "",
                                            style: .normal)
                            .frame(width: size.width/2,
                                   height: size.height,
                                   alignment: .bottomTrailing)
                            .padding(.all, 5)
                    }
                }.frame(width: size.width, height: size.height, alignment: .bottomTrailing)
                
                VStack(alignment: .leading, spacing: 0, content: {
                    Text(pokemon.name.capitalized)
                        .font(Biotif.bold(size: 25).font)
                        .foregroundColor(pokemon.mainType.color.text)
                        .frame(alignment: .topLeading)
                        .lineLimit(1)
                        .padding(.bottom, 10)
                    ForEach(pokemon.types.map({$0.type}).prefix(2)) { type in
                        TypeBubbleCellView(text: type.name,
                                           foregroundColor: pokemon.mainType.color.text,
                                           backgroundColor: Color.white.opacity(0.3),
                                           font: Biotif.semiBold(size: 10).font)
                            .padding(.bottom, 15)
                            .padding(.leading, 15)
                    }
                    Spacer()
                }).frame(width: size.width, height: size.height, alignment: .topLeading)
                .padding(.leading, 25)
                .padding(.top, 35)
               })
            .frame(width: size.width, height: size.height)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(pokemon.mainType.color.background, lineWidth: 5)
            )
            .onAppear {
                viewAppear = true
            }
            .onDisappear {
                viewAppear = false
            }
    }
}

struct TypeBubbleCellView: View {
    var text: String
    var foregroundColor: Color
    var backgroundColor: Color
    var font: Font
    
    var body: some View {
        Text(text)
            .frame(alignment: .leading)
            .font(font)
            .foregroundColor(foregroundColor)
            .background(Rectangle()
                            .fill(backgroundColor)
                            .cornerRadius(10)
                            .padding(EdgeInsets(top: -5, leading: -10, bottom: -5, trailing: -10)))
    }
}
