//
//  TypeListView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct TypeListView: View {
    @StateObject var updater: TypeUpdater = TypeUpdater()
    @State var isLoading = false
    @State var isFirstTimeLoadView: Bool = true
    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 20 - 40) / 2
            let height = (geometry.size.height) / 8
            let gridItem = GridItem(.fixed(width), spacing: 10)
            let columns = [gridItem, gridItem]
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    Color.clear.frame(height: 100)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(updater.typeCells) { cell in
                            TappableTypeCardView(cell: cell,
                                                 size: (width, height),
                                                 avatar: StringHelper.getPokemonId(from: cell.cells.first?.firstPokemon?.url ?? ""))
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        Color.clear.frame(height: 150)
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                    .animation(.linear)
                }
                VStack {
                    CustomText(text: "All Type Available",
                               size: 30,
                               weight: .black,
                               textColor: .black)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 20))
                    Spacer()
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
                if isFirstTimeLoadView {
                    withAnimation(.easeIn) {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isLoading = false
                        }
                    }
                }
                isFirstTimeLoadView = false
            })
        })
    }
}

struct TypeListView_Previews: PreviewProvider {
    static var previews: some View {
        TypeListView()
    }
}
