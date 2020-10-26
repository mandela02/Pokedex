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
    
    let numberOfColumns: CGFloat = Constants.deviceIdiom == .pad ? 3 : 2
    
    var width: CGFloat {
        return (UIScreen.main.bounds.width - 80) / numberOfColumns
    }
    var height: CGFloat {
        width * 0.7
    }
    
    private func calculateGridItem() -> [GridItem] {
        let gridItem = GridItem(.fixed(width), spacing: 10)
        return Array(repeating: gridItem, count: Int(numberOfColumns))
    }

    var body: some View {
        ZStack {
            CustomBigTitleNavigationView(content: {
                LazyVGrid(columns: calculateGridItem()) {
                    ForEach(updater.pokemons) { cell in
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
                .background(GradienView(atTop: true))
            }, maxHeight: 200)
            
            if updater.isLoading {
                LoadingView(background: .white)
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
            }
            
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
