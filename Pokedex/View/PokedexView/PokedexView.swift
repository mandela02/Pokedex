//
//  PokedexView.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI
import Combine

struct NavigationPokedexView: View {
    @EnvironmentObject var environment: EnvironmentUpdater
    @State var showDetail: Bool = false
    @State var showTypeList: Bool = false
    @State var pokemonUrl: String = ""
    @State var pokemonType: PokemonType = .non
    @State var isViewDisplayed = false
    
    var body: some View {
        VStack {
            PokedexView()
                .ignoresSafeArea()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .environmentObject(environment)
            PushOnSigalView(show: $showDetail, destination: {
                PokemonInformationView(pokemonUrl: pokemonUrl,
                                       isShowing: $showDetail)
            })
            PushOnSigalView(show: $showTypeList, destination: {
                PokemonsOfTypeList(show: $showTypeList,
                                   type: pokemonType)
                    .environmentObject(environment)
            })
        }
        .onReceive(environment.$selectedPokemon) { url in
            if !url.isEmpty && isViewDisplayed {
                pokemonUrl = url
                showDetail = true
            }
        }
        .onReceive(environment.$selectedType) { type in
            if type != .non {
                showTypeList = true
                pokemonType = type
            }
        }
        .onAppear {
            isViewDisplayed = true
        }
        .onDisappear {
            isViewDisplayed = false
        }
    }
}

struct PokedexView: View {
    @EnvironmentObject var environment: EnvironmentUpdater
    
    @State private var active = -1
    @State private var showSubView: Bool = false
    @State private var subViewOffset: CGSize = CGSize.zero
    @State private var keyboardHeight: CGFloat = 0
    @State private var showFavorite: Bool = false

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
                    .environmentObject(environment)
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
                            .environmentObject(environment)
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
                PushOnSigalView(show: $showFavorite,
                                destination:  {
                                    FavoriteView(show: $showFavorite)
                                        .environmentObject(environment)
                                        .navigationTitle("")
                                        .navigationBarHidden(true)
                                })
            }
            .onChange(of: active, perform: { active in
                withAnimation(.default) {
                    if active == 3 {
                        showFavorite = true
                        self.active = -1
                        showSubView = false
                    } else if active >= 0 {
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
