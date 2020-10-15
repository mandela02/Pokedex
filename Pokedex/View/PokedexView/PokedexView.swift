//
//  PokedexView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI
import Combine

struct PokedexView: View {
    @State var active = -1
    @State var showSubView: Bool = false
    @State var subViewOffset: CGSize = CGSize.zero
    @State private var keyboardHeight: CGFloat = 0

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
                AllPokemonList()
                    .transition(AnyTransition.move(edge: .leading).combined(with: .opacity))
                    .blur(radius: showSubView ? 3 : 0)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingMenu(active: $active)
                    }
                }
                
                if showSubView {
                    Color.black.opacity(0.5)
                    VStack {
                        Spacer()
                        TypeSubView(isShowing: $showSubView,
                                    offset: $subViewOffset,
                                    kind: SubViewKind.getKind(from: active))
                            .onDisappear { self.keyboardHeight = 0 }
                            .frame(height: geometry.size.height/2)
                            .padding(.bottom, self.keyboardHeight)
                            .onReceive(Publishers.keyboardHeight) {
                                self.keyboardHeight = $0
                            }
                    }
                    .transition(.move(edge: .bottom))
                    .animation(Animation.default.delay(0.1))
                    .offset(y: subViewOffset.height)
                }
            }
            .onChange(of: active, perform: { active in
                withAnimation(.default) {
                    if active >= 0 {
                        showSubView = true
                    }
                }
            })
            .onChange(of: showSubView, perform: { showTypeView in
                if showTypeView == false {
                    active = -1
                    subViewOffset = CGSize.zero
                }
            })
        })
    }
}
