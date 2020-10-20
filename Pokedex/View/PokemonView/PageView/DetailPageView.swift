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
    var color: Color
    @Binding var offset: CGFloat
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = geometry.size.width / CGFloat(numberOfSegment)
            
            ScrollView(.horizontal,
                       showsIndicators: false) {
                Rectangle().fill(color)
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
        Text(tab.title)
            .font(Biotif.bold(size: 15).font)
            .foregroundColor(.black)
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
    
    var species: Species
    var pokemon: Pokemon
    var views: [PageContentView] = []
    
    var body: some View {
        GeometryReader { geometry in
            let views = Tab.allCases
                .map({PageContentView(tab: $0, pokemon: pokemon, species: species, selectedIndex: $selected)})

            PagerView(index: $selected, color: pokemon.mainType.color.background, tabs: Tab.allCases) {
                views
            }
        }
    }
}

struct PageContentView: View, Identifiable {
    var id = UUID()
    
    var tab: Tab
    var pokemon: Pokemon
    var species: Species
    @Binding var selectedIndex: Int
    
    var body: some View {
        switch tab {
        case .about:
            AboutView(pokemon: pokemon, species: species)
        case .stats:
            StatsView(pokemon: pokemon, selectedIndex: $selectedIndex)
        case .evolution:
            EvolutionView(species: species)
        case .moves:
            MovesView(pokemon: pokemon)
        }
    }
}
