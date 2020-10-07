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
    @State var isExpanded = true
    @State var isShowingImage = true
    @State private var offset = CGSize.zero
    
    @State var imageOpacity: Double = 1
    @State var image: UIImage?
    
    @Namespace var namespace
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let detailViewHeight = size.height * 0.6 - offset.height
            
            let collapseValue = geometry.size.height / 4 - 100
            
            ZStack {
                updater.pokemon.mainType.color.background.ignoresSafeArea().saturation(5.0)

                if loadView {
                    if isExpanded {
                        RotatingPokeballView(color: updater.pokemon.mainType.color.background.opacity(0.5))
                            .ignoresSafeArea()
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                    }
                }
                
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 100, alignment: .center)
                        .cornerRadius(25).offset(y: 50)
                    DetailView(selected: $currentTab)
                        .frame(width: size.width, height: detailViewHeight, alignment: .bottom)
                        .background(Color.white)
                }
                .gesture(DragGesture()
                            .onChanged({ gesture in
                                self.offset = gesture.translation
                                let hideImageRequiment = offset.height < 0 && abs(offset.height) > collapseValue
                                withAnimation(.spring()) {
                                    imageOpacity = 1 + Double(offset.height/collapseValue)
                                    isShowingImage = !hideImageRequiment
                                }
                            }).onEnded({ _ in
                                if offset.height < 0 && abs(offset.height) > collapseValue {
                                    withAnimation(.spring()) {
                                        isExpanded = false
                                        offset = CGSize(width: .infinity, height: -size.height * 0.4 )
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        isExpanded = true
                                        offset = CGSize.zero
                                        imageOpacity = 1
                                    }
                                }
                            })
                )

                if loadView {
                    VStack {
                        ButtonView(isShowing: $isShowing,
                                   loadView: $loadView,
                                   isInExpandeMode: $isExpanded,
                                   pokemon: updater.pokemon,
                                   namespace: namespace)
                        if isExpanded {
                            NameView(pokemon: updater.pokemon,
                                     namespace: namespace)
                            TypeView(pokemon: updater.pokemon)
                        }
                        Spacer()
                    }
                }
                
                if isShowingImage {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width * 2/3, height: size.width * 2/3, alignment: .center)
                            .offset(y: -size.width/2 + 30)
                            .matchedGeometryEffect(id: "image", in: namespace)
                            .opacity(imageOpacity)

                    } else {
                        DownloadedImageView(withURL: updater.pokemon.sprites.other.artwork.front, image: $image)
                            .frame(width: size.width * 2/3, height: size.width * 2/3, alignment: .center)
                            .offset(y: -size.width/2 + 30)
                            .matchedGeometryEffect(id: "image", in: namespace)
                            .opacity(imageOpacity)

                    }
                } else {
                    EmptyView().matchedGeometryEffect(id: "image", in: namespace)
                }
            }.ignoresSafeArea()
        })
    }
}

struct ButtonView: View {
    @Binding var isShowing: Bool
    @Binding var loadView: Bool
    @Binding var isInExpandeMode: Bool
    var pokemon: Pokemon
    var namespace: Namespace.ID

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
                    Image(systemName: "suit.heart.fill")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            .padding(.top, 25)
            .padding(.horizontal)
    }
}

struct NameView: View {
    var pokemon: Pokemon
    var namespace: Namespace.ID

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

struct RotatingPokeballView: View {
    @State private var isAnimating = false
    
    var color: Color
    
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
                    .foregroundColor(color)
                    .frame(width: size.width * 2/3, height: size.width * 2/3, alignment: .center)
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                    .animation(self.isAnimating ? foreverAnimation : .default)
                    .onAppear { self.isAnimating = true }
                    .onDisappear { self.isAnimating = false }
                Rectangle().fill(Color.clear)
                    .frame(height: size.height/2 - 55, alignment: .center)
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
        })
        .frame(minWidth: 10, maxWidth: .infinity, alignment: .center)
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
                        .background(Color.red)
                }
            }
            .background(Color.green)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        })
    }
}
