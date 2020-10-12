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
        ScrollView(.vertical, showsIndicators: false) {
            EvolutionChainView(speciesUpdater: speciesUpdater)
                .padding()
        }
    }
}

struct EvolutionChainView: View {
    var speciesUpdater: SpeciesUpdater
    @State var evolutionUpdater: EvolutionUpdater = EvolutionUpdater(of: Species())
    @State var needUpdateView = false
    var body: some View {
        if needUpdateView {
            VStack(alignment: .leading) {
                CustomText(text: "Evolution Chain",
                           size: 20,
                           weight: .bold,
                           textColor: .black)
                
                ForEach(evolutionUpdater.evolutionLinks) { link in
                    EvolutionCellView(evoLink: link)
                }
                Spacer()
            }
        } else {
            Text("No DATA")
                .onReceive(speciesUpdater.$species, perform: { species in
                    if !species.evolutionChain.url.isEmpty {
                        evolutionUpdater = EvolutionUpdater(of: species)
                    }
                }).onReceive(evolutionUpdater.$evolutionLinks, perform: { links in
                    if !links.isEmpty {
                        needUpdateView = true
                    }
                })
        }
    }
}

struct EvolutionCellView: View {
    var evoLink: EvoLink
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            PokemonCellView(species: evoLink.fromSpecies ?? Species())
            Spacer()
            ArrowView()
            Spacer()
            PokemonCellView(species: evoLink.toSpecies ?? Species())
            Spacer()
        }
        .padding()
    }
}

struct ArrowView: View {
    var body: some View {
        VStack {
            HStack {
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
            CustomText(text: "Level 16",
                       size: 12,
                       weight: .semibold)
        }
    }
}

struct PokemonCellView: View {
    @State var image: UIImage?
    var species: Species
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack {
                Image(uiImage: UIImage(named: "ic_pokeball")!.withRenderingMode(.alwaysTemplate))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.gray.opacity(0.5))
                DownloadedImageView(withURL: UrlType.getImageUrlString(of: species.id), needAnimated: false, image: $image)
            }
            CustomText(text: species.name.capitalizingFirstLetter(),
                       size: 15,
                       weight: .semibold)
        }
    }
}
