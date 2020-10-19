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
            if showBall {
                RotatingPokeballView(color: Color(.systemGray4))
                    .scaleEffect(1.2)
            }
            
            FavoriteListView()
            
            VStack {
                VStack {
                    HStack(alignment: .center) {
                        BackButtonView(isShowing: $show)
                        Spacer()
                    }
                    Text("Your Favorite Pokemon")
                        .font(Biotif.extraBold(size: 30).font)
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                }
                .padding(.top, 25)
                .padding(.leading, 20)
                .background(Color.white.opacity(0.5))
                Spacer()
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
        GeometryReader(content: { geometry in
            ZStack {
                if isEmpty {
                    EmptyFavoriteView()
                        .padding(.top, 100)
                } else {
                    PokemonList(cells: $favoriteUpdater.pokemons,
                                isLoading: .constant(false),
                                isFinal: .constant(false),
                                paddingHeader: 150,
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
        })
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
