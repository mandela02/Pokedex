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
    @State var isTapable: Bool = false

    var body: some View {
        PokedexCardView(updater: updater, size: size)
            .onTapGesture(count: 1, perform: {
                withAnimation(.spring()){
                    show.toggle()
                }
            })
            .fullScreenCover(isPresented: $show,
                             content: {
                                PokemonView(updater: updater,
                                                  isShowing: $show)
                             })
            .onReceive(updater.$isFinishLoading) { _ in
                self.isTapable = updater.isFinishLoading
            }
            .disabled(isTapable)
    }
}

struct PokedexCardView: View {
    @ObservedObject var updater: PokemonUpdater

    var size: (width: CGFloat, height: CGFloat)
    
    @State var loaded: Bool = false

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center,
                                    vertical: .center),
               content: {
                updater.pokemon.mainType.color.background.ignoresSafeArea().saturation(5.0)
                Image(uiImage: UIImage(named: "ic_pokeball")!.withRenderingMode(.alwaysTemplate))
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(updater.pokemon.mainType.color.background.opacity(0.5))
                    .frame(width: size.height * 4/5, height: size.height * 4/5, alignment: .bottomTrailing)
                    .offset(x: size.width * 1/4, y: size.height * 1/3 )

                VStack {
                    Spacer()
                    DownloadedImageView(withURL: updater.pokemon.sprites.other.artwork.front)
                        .frame(width: size.width/2,
                               height: size.height,
                               alignment: .bottomTrailing)
                        .padding(.all, 5)
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
                            .font(.system(size: 10))
                            .foregroundColor(updater.pokemon.mainType.color.text)
                            .background(Rectangle()
                                            .fill(updater.pokemon.mainType.color.background.opacity(0.5))
                                            .cornerRadius(10)
                                            .padding(EdgeInsets(top: -5, leading: -10, bottom: -5, trailing: -10)))
                            .padding(.bottom, 15)
                            .padding(.leading, 15)
                    }
                    Spacer()
                }).frame(width: size.width, height: size.height, alignment: .topLeading)
                .padding(.leading, 25)
                .padding(.top, 35)
               })
            .frame(width: size.width, height: size.height)
            .background(Color.clear)
            .cornerRadius(25)
    }
}