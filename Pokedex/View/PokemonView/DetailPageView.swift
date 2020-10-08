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
            SelectedSegmentScrollView(numberOfSegment: 4, offset: $offset)
                .frame(height: 3, alignment: .center)
        }
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
                self.selected = tab.rawValue
            })
    }
}

struct DetailPageView: View {
    @State private var selected: Int = 0
    @State private var offset: CGFloat = 0.0

    var body: some View {
        GeometryReader(content: { geometry in
            VStack(alignment: .center, spacing: 0, content: {
                TabControlView(selected: $selected, offset: $offset)
                PagerView(index: $selected,
                          offset: $offset,
                          pages: (0..<4)
                            .map { index in TextView(text: "\(index)")
                            })
            })
        })
    }
}