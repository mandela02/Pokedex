//
//  EvolutionView.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import SwiftUI

struct EvolutionView: View {
    var speciesUpdater: SpeciesUpdater
    
    var body: some View {
        EvolutionChainView(speciesUpdater: speciesUpdater)
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

struct EvolutionChainView: View {
    var speciesUpdater: SpeciesUpdater
    @StateObject var evolutionUpdater: EvolutionUpdater = EvolutionUpdater(of: Species())
    
    var body: some View {
        List {
            Section (header: CustomText(text: "Evolution Chain",
                                                            size: 20,
                                                            weight: .bold,
                                                            textColor: .black)) {
                ForEach(evolutionUpdater.evolutionLinks) { link in
                    EvolutionCellView(link: link)
                        .padding(.bottom, 5)
                }

            }
            .isRemove(evolutionUpdater.evolutionLinks.isEmpty)

            Section (header: CustomText(text: "Mega Evolution",
                                                            size: 20,
                                                            weight: .bold,
                                                            textColor: .black)) {
                ForEach(evolutionUpdater.megaEvolutionLinks) { link in
                    EvolutionCellView(megaLink: link)
                        .padding(.bottom, 5)
                }
            }
            .isRemove(!speciesUpdater.species.havingMega)
            
            Color.clear.frame(height: 100, alignment: .center)
        }
        .onReceive(speciesUpdater.$species, perform: { species in
            evolutionUpdater.species = species
        })
        .onReceive(speciesUpdater.$evolution, perform: { evolution in
            evolutionUpdater.evolution = evolution
        })
    }
}

struct EvolutionCellView: View {
    var evoLink: EvoLink?
    var megaEvoLink: MegaEvoLink?
    
    init(link: EvoLink? = nil, megaLink: MegaEvoLink? = nil) {
        self.evoLink = link
        self.megaEvoLink = megaLink
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if let link = evoLink {
                Spacer()
                PokemonCellView(species: link.fromSpecies ?? Species())
                ArrowView(trigger: link.triggers ?? "")
                PokemonCellView(species: link.toSpecies ?? Species())
                Spacer()
            } else if let megaLink = megaEvoLink {
                Spacer()
                PokemonCellView(species: megaLink.fromSpecies ?? Species())
                ArrowView(trigger: megaLink.triggers ?? "")
                PokemonCellView(pokemon: megaLink.toPokemon ?? Pokemon())
                Spacer()
            }
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
            CustomText(text: trigger,
                       size: 12,
                       weight: .semibold)
                .foregroundColor(Color.gray.opacity(3))
        }
    }
}

struct PokemonCellView: View {
    @State var image: UIImage?
    @State var show: Bool = false
    
    var updater: PokemonUpdater
    var url: String
    var name: String
    
    init(species: Species? = nil, pokemon: Pokemon? = nil) {
        if let species = species {
            self.url = UrlType.getImageUrlString(of: species.id)
            self.name = species.name
            updater = PokemonUpdater(url: species.pokemon.url)
        } else if let pokemon = pokemon {
            self.url = pokemon.sprites.other.artwork.front ?? ""
            self.name = pokemon.name
            updater = PokemonUpdater(url: UrlType.getPokemonUrl(of: pokemon.pokeId))
        } else {
            self.url = ""
            self.name = ""
            updater = PokemonUpdater(url: "")
        }
    }
    var body: some View {
        Button {
            show = true
        } label: {
            VStack(alignment: .center, spacing: 10) {
                ZStack {
                    Image("ic_pokeball")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.gray.opacity(0.5))
                    DownloadedImageView(withURL: url, needAnimated: true, image: $image)
                }
                CustomText(text: name.capitalizingFirstLetter(),
                           size: 15,
                           weight: .semibold)
            }
            .background(NavigationLink(destination: PokemonView(updater: updater,
                                                                isShowing: $show),
                                       isActive: $show) {
                                        EmptyView()
                                       })
        }
    }
}
