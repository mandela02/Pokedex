//
//  PokedexView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct PokedexView: View {
    @State var active = 5
    @State var showTypeView: Bool = false
    @State var subViewOffset: CGSize = CGSize.zero

    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        
        GeometryReader (content: { geometry in
            ZStack {
                PokemonList()
                    .transition(AnyTransition.move(edge: .leading).combined(with: .opacity))
                    .blur(radius: showTypeView ? 3 : 0)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingMenu(active: $active)
                    }
                }
                
                if showTypeView {
                    Color.black.opacity(0.5)
                    VStack {
                        Spacer()
                        TypeSubView(isShowing: $showTypeView,
                                    offset: $subViewOffset,
                                    kind: SubViewKind.getKind(from: active))
                            .frame(height: geometry.size.height/2)
                    }
                    .offset(y: subViewOffset.height)
                }
            }
            .onChange(of: active, perform: { active in
                withAnimation(.default) {
                    if active < 5 {
                        showTypeView = true
                    }
                }
            })
            .onChange(of: showTypeView, perform: { showTypeView in
                if showTypeView == false {
                    active = 5
                    subViewOffset = CGSize.zero
                }
            })
        })
    }
}
