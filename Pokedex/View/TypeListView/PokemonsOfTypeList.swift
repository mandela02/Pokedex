//
//  TypePokemonListView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct PokemonsOfTypeList: View {
    @State var isLoading = false
    @State var isFirstTimeLoading = true
    
    @Binding var show: Bool
    var type : PokemonType
    @State var isFinal: Bool = false
    
    @StateObject var updater: TypeDetailUpdater = TypeDetailUpdater()
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = geometry.size.height / 6
            VStack(spacing: 0) {
                PokemonOfTypeHeaderView(isLoading: $isLoading,
                                        show: $show,
                                        typeName: updater.name,
                                        damage: updater.damage)
                                
                PokemonList(cells: $updater.pokemons,
                            isLoading: $isLoading,
                            isFinal: $isFinal,
                            cellSize: CGSize(width: geometry.size.width, height: height)) { cell in
                }
            }
            .ignoresSafeArea()
            .onAppear(perform: {
                if isFirstTimeLoading {
                    updater.pokemonType = type
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
                isFirstTimeLoading = false
            })
            .navigationTitle("")
            .navigationBarHidden(true)
        })
    }
}

struct BackButtonView: View {
    @Binding var isShowing: Bool
    var body: some View {
        HStack{
            Button {
                withAnimation(.spring()){
                    isShowing = false
                }
            } label: {
                Image(systemName: ("arrow.uturn.left"))
                    .renderingMode(.template)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.clear)
                    .clipShape(Circle())
            }
            .frame(width: 50, height: 50, alignment: .center)
            Spacer()
        }
        .padding(.top, UIDevice().hasNotch ? 44 : 8)
        .padding(.horizontal)
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
                    Text(typeName.capitalizingFirstLetter())
                        .font(Biotif.extraBold(size: 30).font)
                        .foregroundColor(.black)
                
                    Spacer()
                    
                    if !damage.name.isEmpty {
                        Text("Damage type: " + damage.name)
                            .font(Biotif.extraBold(size: 20).font)
                            .foregroundColor(Color(.systemGray3))
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
