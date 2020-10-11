//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

struct PokemonListView: View {
    @ObservedObject var updater: Updater
    @State var isLoading = false
    
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
            ZStack {
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
                .animation(.linear)
                .listStyle(SidebarListStyle())
                .blur(radius: isLoading ? 3.0 : 0)
    
                VStack {
                    Spacer()
                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0), Color.white.opacity(1)]), startPoint: .top, endPoint: .bottom)
                        .frame(height: 100, alignment: .center)
                        .blur(radius: 3.0)
                }
                
                if isLoading {
                    LoadingView()
                }
            }
            .onReceive(updater.$isLoadingPage, perform: { isLoading in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(Animation.spring()) {
                        self.isLoading = isLoading
                    }
                }
            })
        })
    }
}
