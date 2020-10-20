//
//  FavoriteView.swift
//  Pokedex
//
//  Created by TriBQ on 18/10/2020.
//

import SwiftUI

struct FavoriteView: View {
    @Binding var show: Bool
    @State var showBall: Bool = true
    
    var body: some View {
        ZStack {
            CustomBigTitleNavigationView(content: {
                ZStack {
                    if showBall {
                        RotatingPokeballView(color: Color(.systemGray4))
                            .scaleEffect(1.2)
                    }
                    
                    FavoriteListView()
                }
                .frame(height: UIScreen.main.bounds.height, alignment: .center)
            }, header: {
                    VStack {
                        Text("Your Favorite Pokemon")
                            .font(Biotif.extraBold(size: 30).font)
                            .foregroundColor(.black)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                    }
                    .padding(.top, 75)
                    .padding(.leading, 20)
            }, stickyHeader: {
                    HStack {
                        Spacer()
                        Text("Your Favorite Pokemon")
                            .font(Biotif.extraBold(size: 20).font)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                    .background(Color.white.opacity(0.5))
            }, maxHeight: 150)
            if showBall {
                VStack {
                    HStack(alignment: .center) {
                        BackButtonView(isShowing: $show)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.leading, 20)
            }
        }
        .onAppear {
            showBall = true
        }
        .onWillDisappear {
            showBall = false
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct FavoriteListView: View {
    @StateObject var favoriteUpdater: FavoriteUpdater = FavoriteUpdater()
    @State var isEmpty: Bool = false
    
    var body: some View {
        ZStack {
                if isEmpty {
                    EmptyFavoriteView()
                } else {
                    PokemonList(cells: $favoriteUpdater.pokemons,
                                isLoading: .constant(false),
                                isFinal: .constant(false),
                                paddingHeader: 0,
                                paddingFooter: 50, onCellAppear: { pokemon in })
                }
            }
            .onReceive(favoriteUpdater.didChange) { _ in
                favoriteUpdater.refreshing = true
            }
            .onReceive(favoriteUpdater.$pokemons, perform: { cells in
                isEmpty = cells.isEmpty
            })
            .onAppear {
                if favoriteUpdater.refreshing {
                    favoriteUpdater.update()
                    favoriteUpdater.refreshing = false
                }
            }
    }
}

struct EmptyFavoriteView: View {
    var isShow: Bool = true
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                DotDotDot()
                Image("sad")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(0.8)
            }
            Text("NOTHING can please you!\nGo send some love to your pokemons!")
                .font(Biotif.bold(size: 25).font)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFavoriteView()
    }
}
