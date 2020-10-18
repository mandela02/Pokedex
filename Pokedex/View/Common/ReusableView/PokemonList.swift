//
//  PokemonList.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import SwiftUI

struct PokemonList: View {
    @Binding var cells: [PokemonCellModel]
    @Binding var isLoading: Bool
    @Binding var isFinal: Bool
    
    var paddingHeader: CGFloat
    var paddingFooter: CGFloat
    var cellSize: CGSize

    let onCellAppear: (PokemonCellModel) -> ()
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Color.clear.frame(height: paddingHeader, alignment: .center)

                    ForEach(cells) { cell in
                        PokemonPairCell(firstPokemon: cell.firstPokemon,
                                        secondPokemon: cell.secondPokemon)
                            .listRowInsets(EdgeInsets())
                            .frame(width: cellSize.width, height: cell.firstPokemon == nil ? 0 : cellSize.height)
                            .padding(.bottom, 10)
                            .listRowBackground(Color.clear)
                            .onAppear(perform: {
                                onCellAppear(cell)
                            })
                    }
                    
                    if isFinal {
                        CompleteView().frame(height: 200)
                    }
                    
                    Color.clear.frame(height: paddingFooter, alignment: .center)
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
    }
}
