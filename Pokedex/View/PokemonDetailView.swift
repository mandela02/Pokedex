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
    
    @State var currentTab: Int = 0

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
                    DetailView(selected: $currentTab)
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
                    .offset(y: -size.width/2)
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
                    .frame(height: size.height/2 - 25, alignment: .center)
            })
        })
    }
}

struct TabControlView: View {
    @Binding var selected: Int
    @Namespace var namespace
    var body: some View {
        HStack(alignment: .center, spacing: 1, content: {
            ForEach(0...3, id: \.self) { index in
                TabItem(selected: $selected, tag: index)
            }
        })
    }
}

struct TabItem: View {
    @Binding var selected: Int
    var tag: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Text("\(tag)")
            Rectangle().fill(tag == selected ? Color.blue : Color.clear)
                .frame(height: 3, alignment: .center)
        }).frame(minWidth: 10, idealWidth: .infinity, alignment: .center)
        .frame(height: 50, alignment: .center)
    }
}

struct DetailView: View {
    @Binding var selected: Int

    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            TabControlView(selected: $selected)
            TabView(selection: $selected) {
                ForEach(0...3, id: \.self) { index in
                    Text("\(index)")
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        })
    }
}
