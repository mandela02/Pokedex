//
//  TypePokemonListView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct PokemonsOfTypeList: View {
    @EnvironmentObject var environment: EnvironmentUpdater
    @State var selectedPokemonUrl: String = ""
    @State var isViewDisplayed = false
    @State var showDetail: Bool = false

    @State var isLoading = false
    @State var isFirstTimeLoading = true
    
    @Binding var show: Bool
    var type : PokemonType
    @State var isFinal: Bool = false
    
    @StateObject var updater: TypeDetailUpdater = TypeDetailUpdater()
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = (geometry.size.width - 20) / 2 * 0.7
            ZStack {
                PokemonList(cells: $updater.pokemons,
                            isLoading: $isLoading,
                            isFinal: $isFinal,
                            paddingHeader: 110,
                            paddingFooter: 50,
                            cellSize: CGSize(width: geometry.size.width, height: height)) { cell in
                }.environmentObject(environment)
                
                PushOnSigalView(show: $showDetail, destination: {
                    PokemonInformationView(pokemonUrl: selectedPokemonUrl,
                                           isShowing: $showDetail)
                })
                VStack {
                    PokemonOfTypeHeaderView(isLoading: $isLoading,
                                            show: $show,
                                            typeName: updater.name,
                                            damage: updater.damage)
                        .background(Color.white.opacity(0.5))
                    Spacer()
                }
            }
            .ignoresSafeArea()
            .onAppear(perform: {
                isViewDisplayed = true
                if isFirstTimeLoading {
                    updater.pokemonType = type
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isLoading = false
                    }
                }
                isFirstTimeLoading = false
            })
            .onReceive(environment.$selectedPokemon) { url in
                if !url.isEmpty && isViewDisplayed {
                    selectedPokemonUrl = url
                    showDetail = true
                }
            }
            .onDisappear {
                isViewDisplayed = false
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        })
    }
}

struct PokemonOfTypeHeaderView: View {
    @Binding var isLoading: Bool
    @Binding var show: Bool
    var typeName: String
    var damage: MoveDamageClass
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    BackButtonView(isShowing: $show)
                    Spacer()
                }
                HStack(alignment: .lastTextBaseline) {
                    Text(typeName.capitalized)
                        .font(Biotif.extraBold(size: 30).font)
                        .foregroundColor(.black)
                
                    Spacer()
                    
                    if !damage.name.isEmpty {
                        Text("Damage type: " + damage.name)
                            .font(Biotif.extraBold(size: 20).font)
                            .foregroundColor(Color(.darkGray))
                            .animation(.linear)
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
                .padding(.bottom, 3)

                HStack {
                    Spacer()
                    Text(StringHelper.getEnglishText(from: damage.descriptions))
                        .font(Biotif.regular(size: 15).font)
                        .foregroundColor(Color(.systemGray3))
                        .padding(.trailing, 30)
                        .animation(.linear)
                }
            }
            if isLoading {
                Color.black.opacity(0.5)
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
            }
        }
        .frame(height: 180)
    }
}
