//
//  FavoriteView.swift
//  Pokedex
//
//  Created by TriBQ on 18/10/2020.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var environment: EnvironmentUpdater
    @State var showDetail: Bool = false
    @State var pokemonUrl: String = ""
    @State var isViewDisplayed = false
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            HStack {
                BackButtonView(isShowing: $show)
                Spacer()
            }

            FavoriteListView(show: $show)
                .environmentObject(environment)
            PushOnSigalView(show: $showDetail, destination: {
                PokemonInformationView(pokemonUrl: pokemonUrl,
                                       isShowing: $showDetail)
                    .environmentObject(environment)
            })
        }
        .onReceive(environment.$selectedPokemon) { url in
            if !url.isEmpty && isViewDisplayed {
                pokemonUrl = url
                showDetail = true
            }
        }
        .onAppear {
            isViewDisplayed = true
        }
        .onDisappear {
            isViewDisplayed = false
        }
    }
}

struct FavoriteListView: View {
    @EnvironmentObject var environment: EnvironmentUpdater
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: []) var favorites: FetchedResults<Favorite>
    @Binding var show: Bool
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = (geometry.size.width - 20) / 2 * 0.7
            PokemonList(cells: .constant(prepare()),
                        isLoading: .constant(false),
                        isFinal: .constant(false),
                        cellSize: CGSize(width: geometry.size.width - 10, height: height)) { _ in }
                .environmentObject(environment)
        })
    }
    
    private func prepare() -> [PokemonCellModel]{
        let re = favorites.map({NamedAPIResource(name: "", url: $0.url ?? "")})
        return getCells(from: re)
    }
    
    private func getCells(from result: [NamedAPIResource]) -> [PokemonCellModel] {
        var cells: [PokemonCellModel] = []
        
        result.enumerated().forEach { item in
            if item.offset % 2 == 0 {
                let newPokemons = PokemonCellModel(firstPokemon: item.element, secondPokemon: result[safe: item.offset + 1])
                cells.append(newPokemons)
            }
        }
        
        return cells
    }
}
