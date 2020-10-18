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
        GeometryReader(content: { geometry in
            //            let size = geometry.size
            
            ZStack {
                //                Image("ic_pokeball")
                //                    .resizable()
                //                    .renderingMode(.template)
                //                    .aspectRatio(contentMode: .fit)
                //                    .foregroundColor(Color(.systemGray4))
                //                    .scaleEffect(0.8)
                //                    .blur(radius: 3)
                
                RotatingPokeballView(color: Color(.systemGray4))
                    .scaleEffect(1.2)
                //                    .frame(width: size.width, height: size.height, alignment: .center)
                //                    .offset(x: -(size.width * 1/4 + 25), y: size.height * 3/5)
                
                FavoriteListView(show: $show)
                    .environmentObject(environment)
                PushOnSigalView(show: $showDetail, destination: {
                    PokemonInformationView(pokemonUrl: pokemonUrl,
                                           isShowing: $showDetail)
                        .environmentObject(environment)
                })
                VStack {
                    VStack {
                        HStack(alignment: .center) {
                            BackButtonView(isShowing: $show)
                            Spacer()
                        }
                        Text("Your Favorite Pokemon")
                            .font(Biotif.extraBold(size: 30).font)
                            .foregroundColor(.black)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
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
        })
    }
}

struct FavoriteListView: View {
    @EnvironmentObject var environment: EnvironmentUpdater
    @StateObject var favoriteUpdater: FavoriteUpdater = FavoriteUpdater()
    @Binding var show: Bool
        
    var didChange =  NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = (geometry.size.width - 20) / 2 * 0.7
            PokemonList(cells: $favoriteUpdater.cells,
                        isLoading: .constant(false),
                        isFinal: .constant(false),
                        paddingHeader: 80,
                        paddingFooter: 50,
                        cellSize: CGSize(width: geometry.size.width - 10, height: height)) { _ in }
                .environmentObject(environment)
                .onReceive(didChange) { _ in
                    favoriteUpdater.fetchEntries()
                }
        })
    }
}
