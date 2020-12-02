//
//  EvolutionView.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import SwiftUI

struct EvolutionView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @StateObject var evolutionUpdater: EvolutionUpdater = EvolutionUpdater()
    var species: Species

    var body: some View {
        Group {
            if evolutionUpdater.isLoadingData {
                LoadingView(background: isDarkMode ? Color.black : Color.white)
            } else {
                if evolutionUpdater.evolutionSectionsModels.isEmpty {
                    RotatingPokemonView(message: "No evolution possible", background: isDarkMode ? Color.black : Color.white)
                        
                } else {
                    EvolutionContentViewView(evolutionUpdater: evolutionUpdater, species: species)
                }
            }
        }.onAppear {
            evolutionUpdater.species = species
        }
    }
}

struct EvolutionContentViewView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    @ObservedObject var evolutionUpdater: EvolutionUpdater

    var species: Species
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach((0..<evolutionUpdater.evolutionSectionsModels.count), id:\.self) { index in
                    VStack(spacing: 10) {
                        HStack {
                            Text(evolutionUpdater.evolutionSectionsModels[index].title)
                                .font(Biotif.extraBold(size: 20).font)
                                .foregroundColor(isDarkMode ? .white : .black)
                            Spacer()
                            Image(systemName: "arrowtriangle.right")
                                .renderingMode(.template)
                                .foregroundColor(isDarkMode ? .white : .black)
                                .rotationEffect(.degrees(evolutionUpdater.evolutionSectionsModels[index].isExpanded ? 90 : 0))
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                evolutionUpdater.evolutionSectionsModels[index].isExpanded.toggle()
                            }
                        }
                        if evolutionUpdater.evolutionSectionsModels[index].isExpanded {
                            LazyVStack(alignment: .leading) {
                                ForEach(evolutionUpdater.evolutionSectionsModels[index].data) { data in
                                    VStack {
                                        EvolutionCellView(evoLink: data,
                                                          species: UrlString.getSpeciesUrl(of: species.id))
                                            .padding(.bottom, 5)
                                        Color.clear.frame(height: 5)
                                    }
                                }
                            }
                        }
                        Color.clear.frame(height: 5)
                    }
                }
            }
            Color.clear.frame(height: 100)
        }.frame(alignment: .leading)
        .padding()
        .background(isDarkMode ? Color.black : Color.white)
        .animation(.linear)
    }
}

struct EvolutionCellView: View {
    var evoLink: EvoLink?
    var species: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            PokemonCellView(pokemon: evoLink?.from ?? NamedAPIResource(), species: species)
            ArrowView(trigger: evoLink?.triggers ?? "")
            PokemonCellView(pokemon: evoLink?.to ?? NamedAPIResource(),
                            species: species)
            Spacer()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ArrowView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var trigger: String
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "shift.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(isDarkMode ? .white : .black)
                    .rotationEffect(.init(degrees: 90))
                    .scaleEffect(0.5)
                Image(systemName: "shift.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(isDarkMode ? .white : .black)
                    .rotationEffect(.init(degrees: 90))
                    .scaleEffect(0.5)
            }
            Text(trigger)
                .font(Biotif.semiBold(size: 12).font)
                .foregroundColor(Color.gray.opacity(3))
        }
    }
}

struct PokemonCellView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater

    @State var show: Bool = false
    
    var imageURL: String
    var name: String
    var pokedexCellModel: PokedexCellModel

    var canTap: Bool = true
    
    init(pokemon: NamedAPIResource, species: String) {
        let pokeId = StringHelper.getPokemonId(from: pokemon.url)
        self.pokedexCellModel = PokedexCellModel(pokemonUrl: UrlString.getPokemonUrl(of: pokeId),
                                                 speciesUrl: species)
        self.name = pokemon.name
        self.imageURL = UrlString.getImageUrlString(of: pokeId)
    }
    var body: some View {
        TapToPushView(show: $show) {
            VStack(alignment: .center, spacing: 10) {
                ZStack {
                    Image("ic_pokeball")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.gray.opacity(0.5))
                    DownloadedImageView(withURL: imageURL,
                                        style: .plain)
                }
                Text(name.capitalizingFirstLetter())
                    .font(Biotif.semiBold(size: 15).font)
                    .lineLimit(1)
                    .foregroundColor(isDarkMode ? .white : .black)
            }
        } destination: {
            ParallaxView(pokedexCellModel: pokedexCellModel, isShowing: $show)
        }.disabled(reachabilityUpdater.hasNoInternet)
    }
}
