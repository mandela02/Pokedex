//
//  SubView.swift
//  Pokedex
//
//  Created by TriBQ on 15/10/2020.
//

import SwiftUI

enum SubViewKind: Int, CaseIterable {
    case search
    case type
    case region
    case favorite
    
    var name: String {
        switch self {
        case .search:
            return "Search"
        case .type:
            return "Type"
        case .region:
            return "Region"
        case .favorite:
            return "Favorite"
        }
    }
    
    var image: String {
        switch self {
        case .search:
            return "magnifyingglass"
        case .type:
            return "person.3"
        case .region:
            return "mappin.and.ellipse"
        case .favorite:
            return "heart.circle"
        }
    }

    static func getKind(from index: Int) -> SubViewKind {
        return allCases[safe: index] ?? favorite
    }
}

struct SubView<Content: View>: View {
    @Binding var isShowing: Bool
    @Binding var offset: CGSize
    
    let view: () ->  Content
    
    private func drag(in size: CGSize) -> some Gesture {
        let collapseValue = size.height / 4 - 100
        
        return DragGesture()
            .onChanged({ gesture in
                if gesture.translation.height > 0 {
                    withAnimation(.spring()) {
                        self.offset = gesture.translation
                    }
                }
            }).onEnded({ _ in
                if offset.height > collapseValue {
                    self.isShowing = false
                }
            })
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                VStack {
                    HexColor.white
                        .frame(height: 100, alignment: .center)
                        .cornerRadius(25)
                        .offset(y: 50)
                        .gesture(drag(in: geometry.size))
                    view()
                }
                VStack {
                    Capsule().fill(Color(.systemGray3))
                        .frame(width: 100, height: 5, alignment: .center)
                        .offset(y: 60)
                    Spacer()
                }
            }
        })
    }
}

struct TypeSubView: View {
    @Binding var isShowing: Bool
    @Binding var offset: CGSize
    var kind: SubViewKind
    
    var body: some View {
        SubView(isShowing: $isShowing,
                offset: $offset, view: {
                    getView()
                })
            .transition(AnyTransition
                            .move(edge: .bottom))
    }
    
    private func getView() -> AnyView {
        switch kind {
        case .type:
            return AnyView(AllTypeList().background(Color.white))
        case .search:
            return AnyView(SearchView().background(Color.white))
        default:
            return AnyView(EmptyView())
        }
    }
}

struct SearchView: View {
    @StateObject private var searchUpdater = SearchUpdater()
    
    var body: some View {
        VStack {
            SearchBar(text: $searchUpdater.searchValue)
            List(searchUpdater.pokemonsResource) { pokemon in
                SeachResultCell(name: pokemon.name ?? "", url: pokemon.url ?? "")
            }
            Spacer()
        }
    }
}

struct SeachResultCell: View {
    var name: String
    var url: String
    
    @State var show = false
    var body: some View {
        TapToPushView(show: $show) {
            Text(name.capitalizingFirstLetter())
        } destination: {
            ParallaxView(pokemonUrl: url, isShowing: $show)
        }
    }
}
