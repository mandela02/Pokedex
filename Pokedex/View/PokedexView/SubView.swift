//
//  SubView.swift
//  Pokedex
//
//  Created by TriBQ on 15/10/2020.
//

import SwiftUI

enum SubViewKind: Int, CaseIterable {
    case setting
    case search
    case type
    case region
    case favorite
    
    var name: String {
        switch self {
        case .setting:
            return "Setting"
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
        case .setting:
            return "gear"
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
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

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
        .background(isDarkMode ? Color.black.clipShape(CustomCorner(corner: [.topLeft, .topRight])) : Color.white.clipShape(CustomCorner(corner: [.topLeft, .topRight])))
        .offset(y: offset.height)
        .frame(height: UIScreen.main.bounds.height/1.8)
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
            return AnyView(AllTypeList())
        case .search:
            return AnyView(SearchView())
        case .region:
            return AnyView(RegionGridView())
        default:
            return AnyView(EmptyView())
        }
    }
}

struct SearchView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @StateObject private var searchUpdater = SearchUpdater()
    
    var body: some View {
        ZStack {
            isDarkMode ? Color.black : Color.white
            VStack {
                SearchBar(text: $searchUpdater.searchValue)
                ScrollView {
                    LazyVStack {
                        ForEach(searchUpdater.pokemonsResource) { pokemon in
                            SeachResultCell(name: pokemon.name ?? "", url: pokemon.url ?? "")
                                .frame(height: 44.0, alignment: .leading)
                        }
                    }
                }.background(isDarkMode ? Color.black : Color.white)
                Spacer()
            }
        }
    }
}

struct SeachResultCell: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var name: String
    var url: String
    
    @State var show = false
    var body: some View {
        TapToPushView(show: $show) {
            Text(name.capitalizingFirstLetter())
                .font(Biotif.medium(size: 15).font)
                .foregroundColor( isDarkMode ? .white : .black)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding(.leading, 10)
        } destination: {
            ParallaxView(pokedexCellModel: PokedexCellModel(pokemonUrl: url,
                                                            speciesUrl: UrlString.getSpeciesUrl(of: StringHelper.getPokemonId(from: url))),
                         isShowing: $show)
        }.background(isDarkMode ? Color.black : Color.white)
    }
}
