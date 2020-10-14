//
//  TypePokemonListView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct TypePokemonListView: View {
    @State var typeCell: TypeCell = TypeCell(type: PokeType(), cells: [])
    @State var isLoading = false

    init(cells: TypeCell) {
        self.typeCell = cells
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = geometry.size.height / 6
            ZStack {
                VStack {
                    List {
                        ForEach(typeCell.cells) { cell in
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
            }
            .onAppear(perform: {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isLoading = false
                }
            })
            .navigationTitle("")
            .navigationBarHidden(true)
        })
    }
}
