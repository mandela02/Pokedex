//
//  TypePokemonListView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct TypePokemonListView: View {

    @State var isLoading = false
    @State var isFirstTimeLoading = true

    @Binding var show: Bool
    var type : PokemonType
    
    @StateObject var updater: TypePokemonsUpdater = TypePokemonsUpdater()
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = geometry.size.height / 6
            ZStack {
                VStack {
                    List {
                        ForEach(updater.pokemons) { cell in
                            PokemonListCellView(firstPokemon: cell.firstPokemon,
                                                secondPokemon: cell.secondPokemon)
                                .listRowInsets(EdgeInsets())
                                .frame(width: geometry.size.width, height: height)
                                .padding(.bottom, 10)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .animation(.linear)
                    .listStyle(SidebarListStyle())
                    .blur(radius: isLoading ? 3.0 : 0)
                }
                
                VStack {
                    Spacer()
                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0),
                                                               Color.white.opacity(1)]),
                                   startPoint: .top, endPoint: .bottom)
                        .frame(height: 100, alignment: .center)
                        .blur(radius: 3.0)
                }
                
                if isLoading {
                    LoadingView()
                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
