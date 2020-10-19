//
//  PokemonList.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import SwiftUI

struct PokemonList: View {
    @Binding var cells: [Pokemon]
    @Binding var isLoading: Bool
    @Binding var isFinal: Bool
        
    var paddingHeader: CGFloat
    var paddingFooter: CGFloat
    
    let onCellAppear: (Pokemon) -> ()
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 80) / 2
            let height = width * 0.7
            let gridItem = GridItem(.fixed(width), spacing: 10)
            let columns = [gridItem, gridItem]
            
            ZStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    Color.clear.frame(height: paddingHeader, alignment: .center)
                    
                    LazyVGrid(columns: columns) {
                        ForEach(cells) { cell in
                            TappablePokemonCell(pokemon: cell, size: CGSize(width: width, height: height))
                                .onAppear {
                                    onCellAppear(cell)
                                }
                        }
                    }
                    .animation(.linear)
                    
                    
                    if isFinal {
                        CompleteView().frame(height: 200)
                    }
                    
                    Color.clear.frame(height: paddingFooter, alignment: .center)
                        .animation(.linear)
                        .listStyle(SidebarListStyle())
                        .blur(radius: isLoading ? 3.0 : 0)
                })
                
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
        })
    }
}
