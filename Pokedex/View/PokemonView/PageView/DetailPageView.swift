//
//  DetailPageView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/8/20.
//

import SwiftUI

enum Tab: Int, CaseIterable {
    case about
    case stats
    case evolution
    case moves
    
    var title: String {
        switch self {
        case .about:
            return "About"
        case .stats:
            return "Base stats"
        case .evolution:
            return "Evolution"
        case .moves:
            return "Moves"
        }
    }
}

struct SelectedSegmentScrollView: View {
    var numberOfSegment: Int
    
    @Binding var offset: CGFloat
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = geometry.size.width / CGFloat(numberOfSegment)
            
            ScrollView(.horizontal,
                       showsIndicators: false) {
                Rectangle().fill(Color.blue)
                    .frame(width: width, height: 3, alignment: .center)
            }
            .offset(x: -offset / CGFloat(numberOfSegment))
        })
    }
}

struct TabItem: View {
    @Binding var selected: Int
    var tab: Tab
    
    var body: some View {
        CustomText(text: tab.title,
                   size: 10,
                   weight: .bold,
                   background: .clear,
                   textColor: .black)
            .frame(alignment: .leading)
            .frame(minWidth: 10, maxWidth: .infinity, alignment: .center)
            .frame(height: 50, alignment: .center)
            .onTapGesture(count: 1, perform: {
                withAnimation(.spring()) {
                    self.selected = tab.rawValue
                }
            })
    }
}

struct DetailPageView: View {
    @State private var selected: Int = 0
    @ObservedObject var updater: SpeciesUpdater
    
    var pokemon: Pokemon
    var views: [PageContentView] = []
    
    var body: some View {
        GeometryReader { geometry in
            if updater.evolution.allChains.isEmpty && !updater.species.havingMega {
                let views = [Tab.about, Tab.stats, Tab.moves]
                    .map({PageContentView(tab: $0, pokemon: pokemon, updater: updater, selectedIndex: $selected)})
                PagerView(index: $selected, pages: views, tabs: [Tab.about, Tab.stats, Tab.moves])
            } else {
                let views = Tab.allCases
                    .map({PageContentView(tab: $0, pokemon: pokemon, updater: updater, selectedIndex: $selected)})
                PagerView(index: $selected, pages: views, tabs: Tab.allCases)
            }
        }
    }
}

struct PageContentView: View, Identifiable {
    var id = UUID()
    
    var tab: Tab
    var pokemon: Pokemon
    
    @ObservedObject var updater: SpeciesUpdater
    @Binding var selectedIndex: Int
    
    var body: some View {
        switch tab {
        case .about:
            AboutView(pokemon: pokemon, updater: updater)
        case .stats:
            StatsView(pokemon: pokemon, selectedIndex: $selectedIndex)
        case .evolution:
            EvolutionView(speciesUpdater: updater)
        case .moves:
            EmptyView()
        }
    }
}
