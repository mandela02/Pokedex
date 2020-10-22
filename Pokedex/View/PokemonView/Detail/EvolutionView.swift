//
//  EvolutionView.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import SwiftUI

struct EvolutionView: View {
    @ObservedObject var evolutionUpdater: EvolutionUpdater
    
    init(species: Species) {
        evolutionUpdater = EvolutionUpdater(of: species)
    }
    
    var body: some View {
        List {
            Section (header: Text("Evolution Chain")
                        .font(Biotif.extraBold(size: 20).font)
                        .foregroundColor(.black)) {
                ForEach(evolutionUpdater.evolutionLinks) { link in
                    EvolutionCellView(evoLink: link)
                        .padding(.bottom, 5)
                }
            }
            .isRemove(evolutionUpdater.evolutionLinks.isEmpty)
            
            Section (header: Text("Mega Evolution")
                        .font(Biotif.extraBold(size: 20).font)
                        .foregroundColor(.black)) {
                ForEach(evolutionUpdater.megaEvolutionLinks) { link in
                    EvolutionCellView(evoLink: link)
                        .padding(.bottom, 5)
                }
            }
            .isRemove(!(evolutionUpdater.species?.havingMega ?? true))
            Color.clear.frame(height: 100, alignment: .center)
        }
        .listStyle(SidebarListStyle())
        .animation(.linear)
    }
}

struct EvolutionCellView: View {
    var evoLink: EvoLink?
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            PokemonCellView(pokemon: evoLink?.from ?? NamedAPIResource())
            ArrowView(trigger: evoLink?.triggers ?? "")
            PokemonCellView(pokemon: evoLink?.to ?? NamedAPIResource())
            Spacer()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ArrowView: View {
    var trigger: String
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "shift.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.black)
                    .rotationEffect(.init(degrees: 90))
                    .scaleEffect(0.5)
                Image(systemName: "shift.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.black)
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
    @State var show: Bool = false
    
    var imageURL: String
    var name: String
    var pokemonUrl: String
    
    var canTap: Bool = true
    
    init(pokemon: NamedAPIResource) {
        let pokeId = StringHelper.getPokemonId(from: pokemon.url)
        pokemonUrl = UrlType.getPokemonUrl(of: pokeId)
        self.name = pokemon.name
        self.imageURL = UrlType.getImageUrlString(of: pokeId)
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
                                        style: .normal)
                }
                Text(name.capitalized)
                    .font(Biotif.semiBold(size: 15).font)
                    .foregroundColor(.black)
            }
        } destination: {
            ParallaxView(pokemonUrl: pokemonUrl, isShowing: $show)
        }
    }
}
