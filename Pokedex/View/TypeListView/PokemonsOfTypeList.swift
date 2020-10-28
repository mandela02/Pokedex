//
//  TypePokemonListView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct PokemonsOfTypeListNavigationView: View {
    
    @Binding var show: Bool
    var type : PokemonType
    
    @State var isFirstTimeLoading = true
    @State var showDetail: Bool = false
    @State var isViewDisplayed = false
    @StateObject var updater: TypeDetailUpdater = TypeDetailUpdater()
    
    var body: some View {
        ZStack {
            CustomBigTitleNavigationView(content: {
                ParallaxPokemonsList(pokemons: updater.pokemons)
            }, header: {
                PokemonOfTypeHeaderView(show: $show, typeName: updater.name, damage: updater.damage)
            }, stickyHeader: {
                NamedHeaderView(name: updater.name)
            }, maxHeight: 200)
                .isRemove(updater.hasNoPokemon)
            
            LoadingView(background: .white)
                .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                .isRemove(!updater.isLoading)

            PokemonsOfTypeEmptyView()
                .isRemove(!updater.hasNoPokemon)
            
            VStack {
                BigTitle(text: updater.name.capitalized)
                Spacer()
            }.isRemove(!updater.hasNoPokemon)
            
            VStack {
                HStack(alignment: .center) {
                    BackButtonView(isShowing: $show)
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 30)
            .padding(.leading, 20)
            
            VStack {
                Spacer()
                GradienView(atTop: false)
                    .frame(height: 100, alignment: .center)
            }
        }
        .onAppear(perform: {
            isViewDisplayed = true
            if isFirstTimeLoading {
                updater.pokemonType = type
            }
            isFirstTimeLoading = false
        })
        .onDisappear {
            isViewDisplayed = false
        }
        .showErrorView(error: $updater.error)
        .showAlert(error: $updater.error)
        .navigationTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct PokemonOfTypeHeaderView: View {
    @Binding var show: Bool
    var typeName: String
    var damage: MoveDamageClass
    
    var body: some View {
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    Text(typeName.capitalized)
                        .font(Biotif.extraBold(size: 30).font)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if !damage.name.isEmpty {
                        Text("Damage type: " + damage.name)
                            .font(Biotif.extraBold(size: 20).font)
                            .foregroundColor(Color(.darkGray))
                    }
                }
                .padding(.top, 75)
                .padding(.leading, 30)
                .padding(.trailing, 30)
                .padding(.bottom, 3)
                
                HStack {
                    Spacer()
                    Text(StringHelper.getEnglishText(from: damage.descriptions))
                        .font(Biotif.regular(size: 15).font)
                        .foregroundColor(Color(.darkGray))
                        .padding(.trailing, 30)
                }
            }
        .frame(height: 180)
    }
}

struct PokemonsOfTypeEmptyView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image("suprise_pikachu")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 2, trailing: 20))
                Text("No Pokemons Founded")
                    .font(Biotif.extraBold(size: 30).font)
            }
        }
    }
}
