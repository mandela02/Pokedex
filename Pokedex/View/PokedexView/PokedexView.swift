//
//  PokedexView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI
import Combine

struct NavigationPokedexView: View {
    var body: some View {
        VStack {
            PokedexView()
                .ignoresSafeArea()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct PokedexView: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    
    @State private var selectedMenu = -1
    @State private var showSubView: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var showFavorite: Bool = false
    @State private var showSetting: Bool = false

    init() {
        initTableView()
    }
    
    var body: some View {
        ZStack {
            AllPokemonList()
                .blur(radius: showSubView ? 3 : 0)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingMenu(selectedMenu: $selectedMenu)
                }
            }
            
            if reachabilityUpdater.hasNoInternet {
                VStack {
                    if UIDevice().hasNotch {
                        Color.clear.frame(height: 25)
                    }
                    NoInternetView()
                }
            }
            
            if showSubView {
                Color.black.opacity(0.5)
                    .onTapGesture {
                        withAnimation(.linear) {
                            showSubView = false
                        }
                    }
                VStack {
                    Spacer()
                    TypeSubView(isShowing: $showSubView,
                                kind: SubViewKind.getKind(from: selectedMenu))
                        .onDisappear { self.keyboardHeight = 0 }
                        .padding(.bottom, self.keyboardHeight)
                        .onReceive(Publishers.keyboardHeight) {
                            self.keyboardHeight = $0
                        }
                }
                .transition(.move(edge: .bottom))
            }
            PushOnSigalView(show: $showFavorite,
                            destination:  { FavoriteView(show: $showFavorite) })
            PushOnSigalView(show: $showSetting,
                            destination:  { SettingView(show: $showSetting) })
        }
        .onChange(of: selectedMenu, perform: { active in
            withAnimation(.default) {
                if active == SubViewKind.setting.rawValue {
                    showSetting = true
                    self.selectedMenu = -1
                    showSubView = false
                } else if active == SubViewKind.favorite.rawValue {
                    showFavorite = true
                    self.selectedMenu = -1
                    showSubView = false
                } else if active >= 0 {
                    showSubView = true
                }
            }
        })
        .onChange(of: showSubView, perform: { showTypeView in
            if showTypeView == false {
                selectedMenu = -1
            }
        })
    }
    
    private func initTableView() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().selectionStyle = .none
    }
}
