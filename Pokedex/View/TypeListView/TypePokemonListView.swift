//
//  TypePokemonListView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct TypePokemonListView: View {
    @StateObject var updater: TypeUpdater = TypeUpdater()
    @State var isLoading = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = geometry.size.height / 6
            ZStack {
                if let list = updater.typeCells.first {
                    VStack {
                        List {
                            ForEach(list.cells) { cell in
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
            .onReceive(updater.$isLoading, perform: { isLoading in
                withAnimation(Animation.spring()) {
                    if isLoading {
                        self.isLoading = isLoading
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isLoading = isLoading
                        }
                    }
                }
            })
        })
    }
}
