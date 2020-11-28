//
//  TypeListView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct AllTypeList: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @StateObject var updater: TypeUpdater = TypeUpdater()
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 20 - 40) / 2
            let height = width * 0.3
            let gridItem = GridItem(.fixed(width), spacing: 10)
            let columns = [gridItem, gridItem]
            ZStack {
                isDarkMode ? Color.black : Color.white
                ScrollView(.vertical, showsIndicators: false) {
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
                    Spacer()
                    if isDarkMode {
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0),
                                                                   Color.black.opacity(1)]),
                                       startPoint: .top, endPoint: .bottom)
                            .frame(height: 100, alignment: .center)
                            .blur(radius: 3.0)
                    } else {
                        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0),
                                                                   Color.white.opacity(1)]),
                                       startPoint: .top, endPoint: .bottom)
                            .frame(height: 100, alignment: .center)
                            .blur(radius: 3.0)
                    }
                }
            }
        })
    }
}
