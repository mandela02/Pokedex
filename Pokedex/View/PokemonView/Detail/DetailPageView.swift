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
        Text(tab.title)
            .font(.system(size: 15))
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

struct TabControlView: View {
    @Binding var selected: Int
    @Binding var offset: CGFloat

    @Namespace var namespace
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 1, content: {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabItem(selected: $selected, tab: tab)
                }
            })
            SelectedSegmentScrollView(numberOfSegment: Tab.allCases.count, offset: $offset)
                .frame(height: 3, alignment: .center)
        }
    }
}

struct DetailPageView: View {
    @State private var selected: Int = 0
    @State private var offset: CGFloat = 0.0
    @Binding var isAllowPaging: Bool
    var pokemon: Pokemon

    var views: [PageContentView] = []
    
    init(of pokemon: Pokemon, isAllowPaging: Binding<Bool>) {
        self.pokemon = pokemon
        views = Tab.allCases.map({PageContentView(tab: $0, pokemon: pokemon)})
        self._isAllowPaging = isAllowPaging
    }

    var body: some View {
        GeometryReader(content: { geometry in
            VStack(alignment: .center, spacing: 0, content: {
                TabControlView(selected: $selected, offset: $offset)
                PagerView(index: $selected,
                          offset: $offset,
                          isAllowPaging: $isAllowPaging,
                          pages: views)
            })
        })
    }
}

struct PageContentView: View, Identifiable {
    var id = UUID()
    
    var tab: Tab
    var pokemon: Pokemon
    var updater: SpeciesUpdater
    
    init(tab: Tab, pokemon: Pokemon) {
        self.tab = tab
        self.pokemon = pokemon
        self.updater = SpeciesUpdater(url: pokemon.species.url)
    }
    
    var body: some View {
        containedView()
    }
    
    func containedView() -> AnyView {
        switch tab {
        case .about:
            return AnyView(AboutView(pokemon: pokemon, updater: updater))
        case .stats:
            return AnyView(StatsView(pokemon: pokemon))
        case .evolution:
            return AnyView(EmptyView())
        case .moves:
            return AnyView(EmptyView())
        }
    }
}
