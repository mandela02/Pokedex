//
//  FavoriteView.swift
//  Pokedex
//
//  Created by TriBQ on 18/10/2020.
//

import SwiftUI

struct FavoriteView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    let numberOfColumns: CGFloat = Constants.deviceIdiom == .pad ? 3 : 2

    @Binding var show: Bool
    @StateObject var favoriteUpdater: FavoriteUpdater = FavoriteUpdater()
    
    var body: some View {
        ZStack {
            if isDarkMode{
                Color.black
            } else {
                Color.white
            }
            // Rotating Ball
            if favoriteUpdater.isTopView {
                RotatingPokeballView(color: Color(.systemGray4))
                    .scaleEffect(1.2)
            }
            
            //Main ScrollView
            if favoriteUpdater.isEmpty {
                ZStack {
                    VStack {
                        BigTitle(text: "Your Favorite Pokemon")
                        Spacer()
                    }
                    EmptyFavoriteView()
                }
            } else {
                CustomBigTitleNavigationView(content: {
                    ParallaxPokemonsList(pokemons: favoriteUpdater.pokemonUrls)
                }, header: {
                    BigTitle(text: "Your Favorite Pokemon")
                }, stickyHeader: {
                    NamedHeaderView(name: "Your Favorite Pokemon")
                }, maxHeight: 150)
                .background(Color.clear)
            }
            // Back Button
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
        .onAppear {
            favoriteUpdater.isTopView = true
        }
        .onWillDisappear {
            favoriteUpdater.isTopView = false
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct EmptyFavoriteView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
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
                .multilineTextAlignment(.center)
                .foregroundColor(isDarkMode ? .white : Color(.darkGray))

        }
    }
}

struct BigTitle: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var text: String
    
    var body: some View {
        Text(text)
            .font(Biotif.extraBold(size: 30).font)
            .foregroundColor(isDarkMode ? .white : .black)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 35)
            .padding(.top, 75)
            .frame(height: 150)
    }
}
