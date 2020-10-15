//
//  AnimatedLikeButton.swift
//  Pokedex
//
//  Created by TriBQ on 11/10/2020.
//

import SwiftUI

struct AnimatedLikeButton: View {
    @Binding var isFavorite: Bool
    
    var body: some View {
        HeartView(isFavorite: $isFavorite)
    }
}

struct HeartView: View {
    @Binding private var showStrokeBorder: Bool
    @Binding private var showSplash: Bool
    @Binding private var showSplashTilted: Bool
    @Binding var showHeart: Bool
    
    init(isFavorite: Binding<Bool>) {
        _showHeart = isFavorite
        _showSplashTilted = isFavorite
        _showSplash = isFavorite
        _showStrokeBorder = isFavorite
    }
    
    var body: some View {
        ZStack {
            Image(systemName: "heart")
                .frame(width: 26, height: 26)
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
            
            Circle()
                .strokeBorder(lineWidth: showStrokeBorder ? 1 : 35/2,
                              antialiased: false)
                .opacity(showStrokeBorder ? 0 : 1)
                .frame(width: 35, height: 35)
                .foregroundColor(.purple)
                .scaleEffect(showStrokeBorder ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.5))
            
            Image("splash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(showSplash ? 0 : 1)
                .frame(width: 48, height: 48)
                .scaleEffect(showSplash ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.5).delay(0.1))
            
            Image("splash_tilted")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(showSplashTilted ? 0 : 1)
                .frame(width: 50, height: 50)
                .scaleEffect(showSplashTilted ? 1.1 : 0)
                .scaleEffect(1.1)
                .animation(Animation.easeOut(duration: 0.5).delay(0.1))
            
            Image(systemName: "heart.fill")
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .foregroundColor(.pink)
                .scaleEffect(showHeart ? 1.1 : 0)
                .animation(Animation.interactiveSpring().delay(0.2))
            
        }.onTapGesture() {
            self.showHeart.toggle()
        }
    }
}
