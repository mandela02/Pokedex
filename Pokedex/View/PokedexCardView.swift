//
//  PokedexCardView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

struct TabableCardView: View {
    @ObservedObject var updater: PokemonUpdater
    var size: (width: CGFloat, height: CGFloat)
    @State var show: Bool = false
    @State var loadView: Bool = false

    var body: some View {
        PokedexCardView(updater: updater, size: size)
            .onTapGesture(count: 1, perform: {
                withAnimation(.spring()){
                    show.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        loadView.toggle()
                    }
                }
            })
            .fullScreenCover(isPresented: $show,
                             content: {
                                PokemonDetailView(updater: updater,
                                                  isShowing: $show,
                                                  loadView: $loadView)
                             })
    }
}

struct PokedexCardView: View {
    @ObservedObject var updater: PokemonUpdater

    var size: (width: CGFloat, height: CGFloat)
        
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center,
                                    vertical: .center),
               content: {
                updater.pokemon.mainType.color.background.ignoresSafeArea().saturation(3.0)
                Image(uiImage: UIImage(named: "ic_pokeball")!.withRenderingMode(.alwaysTemplate))
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: size.width, height: size.height, alignment: .bottomTrailing)
                    .offset(x: size.width * 1/6, y: size.height * 1/4 )

                VStack {
                    Spacer()
                    ZStack {
                        DownloadedImageView(withURL: updater.pokemon.sprites.other.artwork.front)
                            .frame(width: size.width/2,
                                   height: size.height,
                                   alignment: .bottomTrailing)
                            .padding(EdgeInsets(top: 5,
                                                leading: 5,
                                                bottom: 5,
                                                trailing: 5))
                    }
                }.frame(width: size.width, height: size.height, alignment: .bottomTrailing)
                VStack(alignment: .leading, spacing: 0, content: {
                    Text(updater.pokemon.name.capitalizingFirstLetter())
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(updater.pokemon.mainType.color.text)
                        .frame(alignment: .topLeading)
                        .lineLimit(1)
                        .padding(.bottom, 10)
                    ForEach(updater.pokemon.types.map({$0.type}).prefix(2)) { type in
                        Text(type.name)
                            .frame(alignment: .leading)
                            .foregroundColor(updater.pokemon.mainType.color.text)
                            .background(Rectangle()
                                            .fill(updater.pokemon.mainType.color.type)
                                            .cornerRadius(5).padding(.all, -2))
                            .padding(.bottom, 8)
                    }
                    Spacer()
                }).frame(width: size.width, height: size.height, alignment: .topLeading)
                .padding(.leading, 25)
                .padding(.top, 25)
               })
            .frame(width: size.width, height: size.height)
            .background(Color.clear)
            .cornerRadius(25)
    }
}
