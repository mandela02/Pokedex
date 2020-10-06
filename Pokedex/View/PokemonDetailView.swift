//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject var updater: PokemonUpdater
    @Binding var isShowing: Bool
    @Binding var loadView: Bool

    let namespace: Namespace.ID

    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let detailViewHeight = size.height * 0.625
            ZStack {
                updater.pokemon.mainType.color.background.ignoresSafeArea().saturation(3.0)

                if loadView {
                    RotatingPokeballView()
                        .ignoresSafeArea()
                }
                

                VStack {
                    Spacer()
                    Rectangle().fill(Color.gray).frame(height: 100, alignment: .center).cornerRadius(25).offset(y: 50)
                    Text("pokemon")
                        .frame(width: size.width, height: detailViewHeight, alignment: .bottom)
                        .background(Color.gray)
                }

                if loadView {
                    VStack {
                        ButtonView(isShowing: $isShowing, loadView: $loadView)
                        Spacer()
                    }
                }

                DownloadedImageView(withURL: updater.pokemon.sprites.other.artwork.front)
                    .frame(width: size.width * 2/3, height: size.width * 2/3, alignment: .center)
                    .offset(y: -size.width/2 - 10)
                    .matchedGeometryEffect(id: Constants.heroId, in: namespace)
            }.ignoresSafeArea()
        })
    }
}

struct ButtonView: View {
    @Binding var isShowing: Bool
    @Binding var loadView: Bool

    var body: some View {
        HStack{
            Button {
                loadView.toggle()
                withAnimation(.spring()){
                    isShowing.toggle()
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            Spacer()
            Button {
            } label: {
                Image(systemName: "suit.heart.fill")
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
            }
        }
        .padding(.top,35)
        .padding(.horizontal)
    }
}

struct RotatingPokeballView: View {
    @State private var isAnimating = false
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
        GeometryReader (content: { geometry in
            let size = geometry.size
            
            VStack(content: {
                Spacer()
                Image(uiImage: UIImage(named: "ic_pokeball")!.withRenderingMode(.alwaysTemplate))
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: size.width * 2/3, height: size.width * 2/3, alignment: .center)
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                    .animation(self.isAnimating ? foreverAnimation : .default)
                    .onAppear { self.isAnimating = true }
                    .onDisappear { self.isAnimating = false }
                Rectangle().fill(Color.clear)
                    .frame(height: size.height/2, alignment: .center)
            })
        })
    }
}
