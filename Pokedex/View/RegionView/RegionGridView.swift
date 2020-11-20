//
//  RegionGridView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 20/11/2020.
//

import SwiftUI

struct RegionGridView: View {
    @StateObject var updater: RegionUpdater = RegionUpdater()
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 20 - 40) / 2
            let height = width * 0.6
            let gridItem = GridItem(.fixed(width), spacing: 10)
            let columns = [gridItem, gridItem]
            
            ScrollView(.vertical, showsIndicators: false) {
                Color.clear.frame(height: 10)
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(updater.regionCellModels) { region in
                        RegionListCellView(size: CGSize(width: width, height: height),
                                           region: region)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                }
                Color.clear.frame(height: height)
            }
        })
    }
}
