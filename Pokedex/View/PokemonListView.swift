//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

struct PokemonListView: View {
    @ObservedObject var updater: Updater
    
    init(updater: Updater) {
        self.updater = updater
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .singleLine
        UITableView.appearance().separatorColor = .red
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = geometry.size.height / 6
            VStack {
                List {
                    ForEach(updater.pokemonsCells) { cell in
                        let cellHeight = cell.firstPokemon == nil && cell.secondPokemon == nil ? 0.0 : height
                        
                        PokemonListCellView(firstPokemon: cell.firstPokemon,
                                            secondPokemon: cell.secondPokemon)
                            .listRowInsets(EdgeInsets())
                            .frame(width: geometry.size.width, height: cellHeight)
                            .padding(.bottom, 10)
                            .listRowBackground(Color.clear)
                            .onAppear(perform: {
                                updater.loadMorePokemonIfNeeded(current: cell)
                            })
                    }
                }
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity,
                       alignment: .top)
                .animation(.linear)
                .listStyle(SidebarListStyle())
                
                if updater.isLoadingPage {
                    ProgressView()
                }
            }
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .top)
            
        })
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(updater: Updater())
    }
}
