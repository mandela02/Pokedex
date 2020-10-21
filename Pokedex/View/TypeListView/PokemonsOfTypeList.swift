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
    
    let width = (UIScreen.main.bounds.width - 80) / 2
    
    var height: CGFloat {
        width * 0.7
    }
    
    private func calculateGridItem() -> [GridItem] {
        return [GridItem(.fixed(width), spacing: 10), GridItem(.fixed(width), spacing: 10)]
    }
    
    var body: some View {
        ZStack {
            CustomBigTitleNavigationView(content: {
                LazyVGrid(columns: calculateGridItem()) {
                    ForEach(updater.allPokemons) { cell in
                        TappablePokemonCell(pokemon: cell, size: CGSize(width: width, height: height))
                            .background(Color.clear)
                    }
                }
                .animation(.linear)
            }, header: {
                PokemonOfTypeHeaderView(show: $show, typeName: updater.name, damage: updater.damage)
            }, stickyHeader: {
                HStack {
                    Spacer()
                    Text(updater.name.capitalized)
                        .font(Biotif.extraBold(size: 20).font)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.top, 50)
                .padding(.bottom, 20)
                .background(Color.white.opacity(0.5))
            }, maxHeight: 200)
            VStack {
                HStack(alignment: .center) {
                    BackButtonView(isShowing: $show)
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 30)
            .padding(.leading, 20)
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
        ZStack {
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
                            .animation(.linear)
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
                        .animation(.linear)
                }
            }
        }
        .frame(height: 180)
    }
}
