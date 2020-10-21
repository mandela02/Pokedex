//
//  FavoriteView.swift
//  Pokedex
//
//  Created by TriBQ on 18/10/2020.
//

import SwiftUI

struct FavoriteView: View {
    @Binding var show: Bool
    @StateObject var favoriteUpdater: FavoriteUpdater = FavoriteUpdater()
    let width = (UIScreen.main.bounds.width - 80) / 2
    var height: CGFloat {
        width * 0.7
    }
    
    private func calculateGridItem() -> [GridItem] {
        return [GridItem(.fixed(width), spacing: 10), GridItem(.fixed(width), spacing: 10)]
    }
    
    var body: some View {
        ZStack {
            // Rotating Ball
            if favoriteUpdater.isTopView {
                RotatingPokeballView(color: Color(.systemGray4))
                    .scaleEffect(1.2)
            }
            
            //Main ScrollView
            if favoriteUpdater.isEmpty {
                ZStack {
                    VStack {
                        BigTitle()
                        Spacer()
                    }
                    EmptyFavoriteView()
                }
            } else {
                CustomBigTitleNavigationView(content: {
                    VStack {
                        LazyVGrid(columns: calculateGridItem()) {
                            ForEach(favoriteUpdater.pokemons) { cell in
                                TappablePokemonCell(pokemon: cell, size: CGSize(width: width, height: height))
                                    .background(Color.clear)
                            }
                        }
                        Spacer()
                    }
                    .background(Color.clear)
                    .frame(height: UIScreen.main.bounds.height, alignment: .center)
                }, header: {
                    BigTitle()
                }, stickyHeader: {
                    SmallTitle()
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
        .onReceive(favoriteUpdater.didChange) { _ in
            favoriteUpdater.refreshing = true
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
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

struct BigTitle: View {
    var body: some View {
        Text("Your Favorite Pokemon")
            .font(Biotif.extraBold(size: 30).font)
            .foregroundColor(.black)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 35)
            .padding(.top, 75)
            .frame(height: 150)
    }
}

struct SmallTitle: View {
    var body: some View {
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
    }
}
