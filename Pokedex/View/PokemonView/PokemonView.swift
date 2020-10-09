//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import SwiftUI

struct PokemonView: View {
    @ObservedObject var updater: PokemonUpdater
    @Binding var isShowing: Bool
    
    @State private var isExpanded = true
    @State private var isShowingImage = true
    @State private var offset = CGSize.zero

    @State private var opacity: Double = 1
    @State private var isAllowPaging: Bool = true

    @Namespace private var namespace
    
    private var safeAreaOffset: CGFloat {
        return UIDevice().hasNotch ? 0 : 120
    }
    
    private func drag(in size: CGSize) -> some Gesture {
        let collapseValue = size.height / 4 - 100
        
        return DragGesture()
            .onChanged({ gesture in
                if abs(gesture.translation.height) > 50 {
                    let direction = Direction.getDirection(value: gesture)
                    withAnimation(.spring()) {
                        if direction == .up || direction == .down {
                            isAllowPaging = false
                        }
                        self.offset = gesture.translation
                        opacity = 1 + Double(offset.height/collapseValue)
                        hideImage(in: size)
                    }
                }
            }).onEnded({ _ in
                withAnimation(.spring()) {
                    isAllowPaging = true
                    updateView(with: size)
                }
            })
        }
    
    private func hideImage(in size: CGSize) {
        let collapseValue = size.height / 4 - 100
        let hideImageRequiment = offset.height < 0 && abs(offset.height) > collapseValue
        isShowingImage = !hideImageRequiment
    }
    
    private func updateView(with size: CGSize) {
        let collapseValue = size.height / 4 - 100

        if offset.height < 0 && abs(offset.height) > collapseValue {
            withAnimation(.spring()) {
                isExpanded = false
                offset = CGSize(width: .infinity, height: -size.height * 0.4 + safeAreaOffset)
            }
        } else {
            withAnimation(.spring()) {
                isExpanded = true
                offset = CGSize.zero
                opacity = 1
            }
        }
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let detailViewHeight = size.height * 0.6 - offset.height
                        
            ZStack {
                updater.pokemon.mainType.color.background.ignoresSafeArea().saturation(5.0)
                
                if isExpanded {
                    RotatingPokeballView(color: updater.pokemon.mainType.color.background.opacity(0.5))
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                    
                } else {
                    RotatingPokeballView(color: updater.pokemon.mainType.color.background.opacity(0.5))
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width * 4/5, height: geometry.size.height * 4/5, alignment: .center)
                        .offset(x: size.width * 2/5, y: -size.height * 2/5 - 25 )
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .fill(HexColor.white)
                        .frame(height: 100, alignment: .center)
                        .cornerRadius(25)
                        .offset(y: 50)
                    DetailPageView(of: updater.pokemon, isAllowPaging: $isAllowPaging)
                        .frame(width: size.width, height: abs(detailViewHeight), alignment: .bottom)
                        .background(HexColor.white)
                }.simultaneousGesture(drag(in: size))
                
                VStack {
                    ButtonView(isShowing: $isShowing,
                               isInExpandeMode: $isExpanded,
                               pokemon: updater.pokemon,
                               namespace: namespace)
                    if isExpanded {
                        NameView(pokemon: updater.pokemon,
                                 namespace: namespace,
                                 opacity: $opacity)
                        TypeView(pokemon: updater.pokemon)
                            .opacity(opacity)
                    }
                    Spacer()
                }
                
                if isShowingImage {
                    DownloadedImageView(withURL: updater.pokemon.sprites.other.artwork.front)
                        .frame(width: size.width * 2/3, height: size.height * 1/3, alignment: .center)
                        .offset(y: -size.width/2 + 30)
                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                        .opacity(opacity)
                }
            }
            .ignoresSafeArea()
        })
    }
}

struct ButtonView: View {
    @Binding var isShowing: Bool
    @Binding var isInExpandeMode: Bool
    var pokemon: Pokemon
    var namespace: Namespace.ID
    
    var isFavorite = false

    var body: some View {
            HStack{
                Button {
                    withAnimation(.spring()){
                        isShowing.toggle()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.clear)
                        .clipShape(Circle())
                }
                Spacer()
                if !isInExpandeMode {
                    Text(pokemon.name.capitalizingFirstLetter())
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(pokemon.mainType.color.text)
                        .background(Color.clear)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "nameText", in: namespace)
                    Spacer()
                }
                Button {
                } label: {
                    Image(systemName:  isFavorite ? "suit.heart.fill" : "suit.heart")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.clear)
                        .clipShape(Circle())
                }
            }
            .padding(.top, UIDevice().hasNotch ? 50 : 8)
            .padding(.horizontal)
    }
}

struct NameView: View {
    var pokemon: Pokemon
    var namespace: Namespace.ID

    @Binding var opacity: Double
    
    var body: some View {
        HStack(alignment: .lastTextBaseline){
            Text(pokemon.name.capitalizingFirstLetter())
                .font(.system(size: 35))
                .fontWeight(.bold)
                .foregroundColor(pokemon.mainType.color.text)
                .background(Color.clear)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .matchedGeometryEffect(id: "nameText", in: namespace)
            Spacer()
            Text(String(format: "#%03d", pokemon.order))
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(pokemon.mainType.color.text)
                .background(Color.clear)
                .frame(alignment: .topLeading)
                .lineLimit(1)
                .opacity(opacity)
        }
        .background(Color.clear)
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.horizontal)
    }
}

struct TypeView: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack(alignment: .center, spacing: 30, content: {
            ForEach(pokemon.types.map({$0.type})) { type in
                Text(type.name)
                    .frame(alignment: .leading)
                    .font(.system(size: 15))
                    .foregroundColor(pokemon.mainType.color.text)
                    .background(Rectangle()
                                    .fill(pokemon.mainType.color.background.opacity(0.5))
                                    .cornerRadius(10)
                                    .padding(EdgeInsets(top: -5, leading: -10, bottom: -5, trailing: -10)))
            }
            Spacer()
        })
        .padding(.leading, 40)
        .padding(.top, 5)
        .background(Color.clear)
    }
}
