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
            .isRemove(!speciesUpdater.species.havingMega)
            
            Color.clear.frame(height: 100, alignment: .center)
        }
        .onReceive(speciesUpdater.$species, perform: { species in
            evolutionUpdater.species = species
        })
        .onReceive(speciesUpdater.$evolution, perform: { evolution in
            evolutionUpdater.evolution = evolution
        })
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
    
    @State var image: UIImage?
    @State var show: Bool = false
    
    var updater: PokemonUpdater
    var url: String
    var name: String
    
    var canTap: Bool = true
    
    init(pokemon: NamedAPIResource) {
        let pokeId = StringHelper.getPokemonId(from: pokemon.url)
        self.name = pokemon.name
        self.url = UrlType.getImageUrlString(of: pokeId)
        self.updater = PokemonUpdater(url: UrlType.getPokemonUrl(of: pokeId))
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
                    DownloadedImageView(withURL: url,
                                        needAnimated: false,
                                        image: $image)
                }
                Text(name.capitalizingFirstLetter())
                    .font(Biotif.semiBold(size: 15).font)
                    .foregroundColor(.black)
            }
            .background(NavigationLink(destination: PokemonView(updater: updater,
                                                                isShowing: $show),
                                       isActive: $show) {
                EmptyView()
            })
        }
    }
}


struct CustomAlertView: View {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack {
                Image("ic_pokeball")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.gray.opacity(0.5))
                Image(uiImage: image ?? UIImage())
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.gray.opacity(0.5))
            }
            Button(action: {
                withAnimation(.linear) {
                    isPresented = false
                }
            }, label: {
                Text("OK")
                    .font(Biotif.bold(size: 25).font)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           alignment: .center)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(20)
            })
        }.background(Color.clear)
    }
}
