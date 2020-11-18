//
//  PokemonList.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import SwiftUI

struct PokemonList: View {
    var cells: [PokedexCellModel]
    @Binding var isLoading: Bool
    @Binding var isFinal: Bool
        
    var paddingHeader: CGFloat
    var paddingFooter: CGFloat
    
    let onCellAppear: (PokedexCellModel) -> ()
    
    let numberOfColumns: CGFloat = Constants.deviceIdiom == .pad ? 3 : 2
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 80) / numberOfColumns
            let height = width * 0.7
            let gridItem = GridItem(.fixed(width), spacing: 10)
            let columns: [GridItem] = Array(repeating: gridItem, count: Int(numberOfColumns))
            
            ZStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    Color.clear.frame(height: paddingHeader, alignment: .center)
                    
                    Text("Pokedex")
                        .font(Biotif.bold(size: 50).font)
                        .foregroundColor(.black)
                        .padding(.all, 20)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: columns) {
                        ForEach(cells) { cell in
                            TappablePokemonCell(pokedexCellModel: cell, size: CGSize(width: width, height: height))
                                .background(Color.clear)
                                .onAppear {
                                    onCellAppear(cell)
                                }
                        }
                    }.animation(.linear)
                    
                    if isFinal {
                        CompleteView().frame(height: 200)
                    }
                    
                    Color.clear.frame(height: paddingFooter, alignment: .center)
                })
                .blur(radius: isLoading ? 3.0 : 0)
                
                VStack {
                    Spacer()
                    GradienView(atTop: false)
                        .frame(height: 100, alignment: .center)
                }
                
                if isLoading {
                    LoadingView(background: .white)
                }
            }
        })
    }
}

struct GradienView: View {
    var atTop: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0),
                                                   Color.white.opacity(1)]),
                       startPoint: atTop ? .bottom : .top, endPoint: atTop ? .top : .bottom)
            .blur(radius: 3.0)
    }
}
