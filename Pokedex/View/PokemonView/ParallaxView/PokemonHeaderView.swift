//
//  HeaderView.swift
//  Pokedex
//
//  Created by TriBQ on 20/10/2020.
//

import SwiftUI

struct PokemonHeaderView: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    @Binding var isShowing: Bool
    @Binding var isInExpandeMode: Bool
    @Binding var opacity: Double
    @Binding var showLikedNotification: Bool
    @Binding var isDisabled: Bool

    var pokemon: Pokemon

    var body: some View {
        VStack {
            NewButtonView(isShowing: $isShowing, isInExpandeMode: $isInExpandeMode, showLikedNotification: $showLikedNotification, isDisabled: $isDisabled, pokemon: pokemon)
            if reachabilityUpdater.hasNoInternet {
                NoInternetView()
            } else {
                NewNameView(pokemon: pokemon, opacity: $opacity)
                NewTypeView(pokemon: pokemon, isInExpandeMode: $isInExpandeMode)
            }
            Spacer()
        }
    }
}

struct NewButtonView: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: []) var favorites: FetchedResults<Favorite>

    @Binding var isShowing: Bool
    @Binding var isInExpandeMode: Bool
    @Binding var showLikedNotification: Bool
    @Binding var isDisabled: Bool

    var pokemon: Pokemon
    
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
            if isInExpandeMode {
                Text(pokemon.name.capitalizingFirstLetter())
                    .font(Biotif.bold(size: 25).font)
                    .fontWeight(.bold)
                    .foregroundColor(pokemon.mainType.color.text)
                    .background(Color.clear)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
                Spacer()
            }
            AnimatedLikeButton(isFavorite: $isFavorite, onTap: {
                if isFavorite {
                    like(pokemon: pokemon)
                } else {
                    dislike(pokemon: pokemon)
                }
            })
            .disabled(reachabilityUpdater.hasNoInternet)
            .disabled(isDisabled)
            .padding()
            .background(Color.clear)
            .clipShape(Circle())
            .frame(width: 50, height: 50, alignment: .center)
        }
        .padding(.top, UIDevice().hasNotch ? 44 : 8)
        .padding(.horizontal)
        .onChange(of: pokemon.pokeId, perform: { id in
            if id != 0 {
                isFavorite = favorites.map({$0.url}).contains(UrlType.getPokemonUrl(of: id))
            }
        })
        .onAppear {
            if pokemon.pokeId != 0 {
                isFavorite = favorites.map({$0.url}).contains(UrlType.getPokemonUrl(of: pokemon.pokeId))
            }
        }
    }
    
    private func like(pokemon: Pokemon) {
        CoreData.like(pokemon: UrlType.getPokemonUrl(of: pokemon.pokeId))
        showLikedNotification = true
    }
    
    private func dislike(pokemon: Pokemon) {
        CoreData.dislike(pokemon: UrlType.getPokemonUrl(of: pokemon.pokeId))
    }
}

struct NewNameView: View {
    var pokemon: Pokemon
    
    @Binding var opacity: Double
    
    var body: some View {
        HStack(alignment: .lastTextBaseline){
            Text(pokemon.name.capitalizingFirstLetter())
                .font(Biotif.bold(size: 35).font)
                .fontWeight(.bold)
                .foregroundColor(pokemon.mainType.color.text)
                .background(Color.clear)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .opacity(opacity)
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

struct NewTypeView: View {
    let pokemon: Pokemon
    @Binding var isInExpandeMode: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 30, content: {
            ForEach(pokemon.types.map({$0.type})) { type in
                TappableNewTypeView(type: type)
            }
            Spacer()
        })
        .padding(.leading, 40)
        .padding(.top, 5)
        .background(Color.clear)
        .isRemove(isInExpandeMode)
    }
}

struct TappableNewTypeView: View {
    var type: NamedAPIResource
    @State var isShow = false
    
    var body: some View {
        TapToPushView(show: $isShow) {
            Text(type.name)
                .frame(alignment: .leading)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .background(Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .cornerRadius(10)
                                .padding(EdgeInsets(top: -5, leading: -10, bottom: -5, trailing: -10)))
        } destination: {
            PokemonsOfTypeListNavigationView(show: $isShow, type: PokemonType.type(from: type.name))
        }
    }
}
