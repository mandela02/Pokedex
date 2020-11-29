//
//  PokemonList.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import SwiftUI

struct PokemonList: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var cells: [PokedexCellModel]
    @Binding var isLoading: Bool
    @Binding var isFinal: Bool
        
    var paddingHeader: CGFloat
    var paddingFooter: CGFloat
    @State var textColor = Color.black
    @State var isScrollToTop = false
    @State var isShowScrollButton = false

    let onCellAppear: (PokedexCellModel) -> ()
    
    let numberOfColumns: CGFloat = Constants.deviceIdiom == .pad ? 3 : 2
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 80) / numberOfColumns
            let height = width * 0.7
            let gridItem = GridItem(.fixed(width), spacing: 10)
            let columns: [GridItem] = Array(repeating: gridItem, count: Int(numberOfColumns))
            
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false, content: {
                        Color.clear.frame(height: paddingHeader, alignment: .center)
                        
                        Text("Pokedex")
                            .font(Biotif.bold(size: 50).font)
                            .foregroundColor(textColor)
                            .padding(.all, 20)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .id("Pokedex")

                        LazyVGrid(columns: columns) {
                            ForEach(cells) { cell in
                                TappablePokemonCell(pokedexCellModel: cell, size: CGSize(width: width, height: height))
                                    .background(Color.clear)
                                    .onAppear {
                                        onCellAppear(cell)
                                        if cell.pokemonUrl == UrlString.getPokemonUrl(of: 20) {
                                            withAnimation {
                                                isShowScrollButton = true
                                            }
                                        }
                                        if cell.pokemonUrl == UrlString.getPokemonUrl(of: 10) {
                                            withAnimation {
                                                isShowScrollButton = false
                                            }
                                        }
                                    }.id(cell.pokemonUrl)
                            }
                        }.animation(.linear)
                        
                        if isFinal {
                            CompleteView().frame(height: 200)
                        }
                        
                        Color.clear.frame(height: paddingFooter, alignment: .center)
                    })
                    .onChange(of: isScrollToTop, perform: { newValue in
                        if newValue {
                            withAnimation {
                                proxy.scrollTo("Pokedex")
                                isScrollToTop = false
                            }
                        }
                    })
                }
                
                VStack {
                    Spacer()
                    GradienView(atTop: false)
                        .frame(height: 100, alignment: .center)
                }
                
                if isShowScrollButton {
                    VStack {
                        Spacer()
                        Button {
                            isScrollToTop = true
                        } label: {
                            Image(systemName: "arrow.up")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .clipShape(Circle())
                        }.frame(width: 60, height: 60, alignment: .center)
                        .padding(.bottom, 30)
                    }
                }
                
                if isLoading {
                    LoadingView(background: isDarkMode ? .black : .white)
                }
            }
        }).onChange(of: isDarkMode, perform: { value in
              textColor = value ? .white : .black
        }).onAppear(perform: {
            textColor = isDarkMode ? .white : .black
        })
    }
}

struct GradienView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var atTop: Bool
    
    var body: some View {
        if isDarkMode {
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0),
                                                       Color.black.opacity(1)]),
                           startPoint: atTop ? .bottom : .top, endPoint: atTop ? .top : .bottom)
                .blur(radius: 3.0)
        } else {
            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0),
                                                       Color.white.opacity(1)]),
                           startPoint: atTop ? .bottom : .top, endPoint: atTop ? .top : .bottom)
                .blur(radius: 3.0)
        }
    }
}
