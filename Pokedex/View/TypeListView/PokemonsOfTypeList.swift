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
    
    @StateObject var updater: TypePokemonsUpdater = TypePokemonsUpdater()
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = geometry.size.height / 6
            ZStack {
                PokemonList(cells: $updater.pokemons,
                            isLoading: $isLoading,
                            isFinal: $isFinal,
                            cellSize: CGSize(width: geometry.size.width, height: height)) { cell in
                }
                VStack {
                    HStack {
                        BackButtonView(isShowing: $show)
                        Spacer()
                    }
                    Spacer()
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
