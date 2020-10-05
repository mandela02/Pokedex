//
//  PokedexCardView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

struct PokedexCardView: View {
    var pokemon: Pokemon
    var size: (width: CGFloat, height: CGFloat)
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center,
                                    vertical: .center),
               content: {
                pokemon.mainType.color.background.ignoresSafeArea()
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
                        DownloadedImageView(withURL: pokemon.imageUrl)
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
                    Text(pokemon.name)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(pokemon.mainType.color.text)
                        .frame(alignment: .topLeading)
                        .lineLimit(1)
                        .padding(.bottom, 10)
                    ForEach(pokemon.types) { type in
                        Text(type.name)
                            .frame(alignment: .leading)
                            .foregroundColor(pokemon.mainType.color.text)
                            .background(Rectangle()
                                            .fill(pokemon.mainType.color.type)
                                            .cornerRadius(5).padding(.all, -2))
                            .padding(.bottom, 8)
                    }
                    Spacer()
                }).frame(width: size.width, height: size.height, alignment: .topLeading)
                .padding(.leading, 25)
                .padding(.top, 25)
               })
            .frame(width: size.width, height: size.height)
            .cornerRadius(20)
    }
}

struct DownloadedImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(withURL url: String) {
        imageLoader = ImageLoader(url: url)
    }
    
    var body: some View {
        Image(uiImage: imageLoader.displayImage ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:100, height:100)
    }
}

struct PokedexCardView_Previews: PreviewProvider {
    static let updater = Updater()
    
    static var previews: some View {
        PokedexCardView(pokemon: updater.pokemons[0], size: (200, 150))
    }
}
