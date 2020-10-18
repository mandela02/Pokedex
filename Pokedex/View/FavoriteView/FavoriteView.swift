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
        ZStack {
            FavoriteListView(show: $show)
                .environmentObject(environment)
            PushOnSigalView(show: $showDetail, destination: {
                PokemonInformationView(pokemonUrl: pokemonUrl,
                                       isShowing: $showDetail)
                    .environmentObject(environment)
            })
            VStack {
                HStack {
                    BackButtonView(isShowing: $show)
                    Spacer()
                }
                .padding(.top, 25)
                .padding(.leading, 20)
                .background(Color.white.opacity(0.5))
                Spacer()
            }
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
        .navigationTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct FavoriteListView: View {
    // FetchRequest only available in SwiftUI View
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: []) var favorites: FetchedResults<Favorite>
    
    @EnvironmentObject var environment: EnvironmentUpdater
    @StateObject var favoriteUpdater: FavoriteUpdater = FavoriteUpdater()
    @Binding var show: Bool
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = (geometry.size.width - 20) / 2 * 0.7
            PokemonList(cells: $favoriteUpdater.cells,
                        isLoading: .constant(false),
                        isFinal: .constant(false),
                        paddingHeader: 50,
                        paddingFooter: 50,
                        cellSize: CGSize(width: geometry.size.width - 10, height: height)) { _ in }
                .environmentObject(environment)
                .onAppear {
                    favoriteUpdater.favorites = favorites.map({$0})
                }
        })
    }
}
