//
//  TypeListView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct AllTypeList: View {
    @StateObject var updater: TypeUpdater = TypeUpdater()
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 20 - 40) / 2
            let height = (geometry.size.height) / 8
            let gridItem = GridItem(.fixed(width), spacing: 10)
            let columns = [gridItem, gridItem]
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    Color.clear.frame(height: 50)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(updater.allTypes, id: \.self) { type in
                            TappableTypeCardView(type: type,
                                                 size: (width, height))
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        Color.clear.frame(height: 150)
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                    .animation(.linear)
                }
                VStack {
                    Text("All Type Available")
                        .font(Biotif.black(size: 30).font)
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
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
            }
        })
    }
}

struct TypeListView_Previews: PreviewProvider {
    static var previews: some View {
        AllTypeList()
    }
}
