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
    @State var offset: CGSize = CGSize.zero
    
    let view: () ->  Content
    
    private func drag() -> some Gesture {
        let collapseValue = UIScreen.main.bounds.height / 3
        
        return DragGesture()
            .onChanged({ gesture in
                if gesture.translation.height > 0 {
                    self.offset = gesture.translation
                }
            }).onEnded({ gesture in
                withAnimation(Animation.easeIn(duration: 0.2)) {
                    if gesture.translation.height > collapseValue / 1.5 {
                        isShowing = false
                    }
                    self.offset = CGSize.zero
                }
            })
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Capsule().fill(Color(.systemGray3))
                .frame(width: 60, height: 4, alignment: .center)
            view()
        }
        .background(Color.white.clipShape(CustomCorner(corner: [.topLeft, .topRight])))
        .offset(y: offset.height)
        .frame(height: UIScreen.main.bounds.height/2)
        .gesture(drag())
    }
}

struct TypeSubView: View {
    @Binding var isShowing: Bool
    var kind: SubViewKind
    
    var body: some View {
        SubView(isShowing: $isShowing,
                view: {
                    getView()
                })
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
            ParallaxView(pokedexCellModel: PokedexCellModel(pokemonUrl: url,
                                                            speciesUrl: UrlType.getSpeciesUrl(of: StringHelper.getPokemonId(from: url))),
                         isShowing: $show)
        }
    }
}
