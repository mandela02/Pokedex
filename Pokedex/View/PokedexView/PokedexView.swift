//
//  PokedexView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct PokedexView: View {
    @State var active = 0
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        ZStack {
            switch active {
            case 0:
                PokemonListView()
                    .transition(AnyTransition.move(edge: .leading).combined(with: .opacity))
            case 1:
                TypeListView()
                    .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
            case 2:
                EmptyView()
            default:
                EmptyView()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingMenu(active: $active)
                        .padding(.bottom, 30)
                        .padding(.trailing, 30)
                }
            }
        }
    }
}
