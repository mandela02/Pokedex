//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import SwiftUI

struct PokemonInformationView: View {
    @StateObject var voiceUpdater: VoiceHelper = VoiceHelper()
    
    @ObservedObject var updater: PokemonUpdater
    @StateObject var speciesUpdater: SpeciesUpdater = SpeciesUpdater(url: "")
    
    @Binding var isShowing: Bool
    
    @State private var isExpanded = true
    @State private var isShowingImage = true
    @State private var offset = CGSize.zero
    @State private var opacity: Double = 1
    @State private var isFirstTimeLoadView = true
    
    @State private var currentImage: UIImage?
    
    @Namespace private var namespace
    
    init(updater: PokemonUpdater? = nil, pokemonUrl: String? = nil, isShowing: Binding<Bool>) {
        if let updater = updater {
            self.updater = updater
        } else {
            self.updater = PokemonUpdater(url: pokemonUrl ?? "")
        }
        self._isShowing = isShowing
    }
    
    private var safeAreaOffset: CGFloat {
        return UIDevice().hasNotch ? 0 : 120
    }
    
    private func drag(in size: CGSize) -> some Gesture {
        let collapseValue = size.height / 4 - 100
        
        return DragGesture()
            .onChanged({ gesture in
                if abs(gesture.translation.height) > 50 {
                    let direction = Direction.getDirection(value: gesture)
                    if direction == .down || direction == .up {
                        withAnimation(.spring()) {
                            self.offset = gesture.translation
                            opacity = 1 + Double(offset.height/collapseValue)
                            hideImage(in: size)
                        }
                    }
                }
            }).onEnded({ gesture in
                let direction = Direction.getDirection(value: gesture)
                if direction == .down || direction == .up {
                    withAnimation(.spring()) {
                        updateView(with: size)
                    }
                } else if direction == .right {
                    updater.moveBack()
                } else {
                    updater.moveForward()
                }
            })
    }
    
    private func resetImage() {
        currentImage = nil
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
    
    private func image(from url: String,
                       size: CGSize,
                       style: LoadStyle,
                       image: Binding<UIImage?> = .constant(nil),
                       offset: CGFloat) -> some View {
        DownloadedImageView(withURL: url,
                            image: image,
                            style: style)
            .frame(width: size.width * 2/3, height: size.height * 1/3, alignment: .center)
            .offset(x: offset, y: -size.width/2 + 30)
            .opacity(opacity)
            .gesture(drag(in: size))
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let detailViewHeight = size.height * 0.6 - offset.height
            
            ZStack {
                updater.pokemon.mainType.color.background.ignoresSafeArea()
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
                    .animation(Animation.linear)
                
                if isExpanded {
                    RotatingPokeballView()
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                } else {
                    RotatingPokeballView()
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width * 4/5,
                               height: geometry.size.height * 4/5,
                               alignment: .center)
                        .offset(x: size.width * 2/5, y: -size.height * 2/5 - 25 )
                }
                
                if isShowingImage {
                    image(from: UrlType.getImageUrlString(of: updater.previousId),
                          size: size,
                          style: .silhoutte,
                          offset: -size.width * 4/5 + 30)
                        .scaleEffect(0.6)
                        .padding(.bottom, 100)
                        .blur(radius: 2.0)
                    image(from: UrlType.getImageUrlString(of: updater.nextId),
                          size: size,
                          style: .silhoutte,
                          offset: size.width * 4/5 - 30)
                        .scaleEffect(0.6)
                        .blur(radius: 2.0)
                        .padding(.bottom, 100)
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    HexColor.white
                        .frame(height: 100, alignment: .center)
                        .cornerRadius(25)
                        .offset(y: 50)
                    DetailPageView(updater: speciesUpdater, pokemon: updater.pokemon)
                        .frame(width: size.width, height: abs(detailViewHeight), alignment: .bottom)
                        .background(HexColor.white)
                        .isRemove(!isShowing)
                }.gesture(drag(in: size))
                
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
                    image(from: updater.pokemon.sprites.other.artwork.front ?? "",
                          size: size,
                          style: .animated,
                          image: $currentImage,
                          offset: 0)
                }
                
                VStack() {
                    Spacer()
                    HStack {
                        Spacer()
                        PulsatingPlayButton(isSpeaking: $voiceUpdater.isSpeaking,
                                            about: $updater.pokemon)
                            .padding(.trailing, 30)
                            .padding(.bottom, 30)
                            .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
                            .animation(.default)
                    }
                }
            }
            .ignoresSafeArea()
            .onChange(of: currentImage) { image in

                if isFirstTimeLoadView {
                    voiceUpdater.isSpeaking = true
                    isFirstTimeLoadView = false
                }
            }
            .onReceive(updater.$currentId, perform: { pokemon in
                if speciesUpdater.speciesUrl != updater.pokemon.species.url {
                    speciesUpdater.speciesUrl = updater.pokemon.species.url
                    resetImage()
                    voiceUpdater.pokemon = updater.pokemon
                    isFirstTimeLoadView = true
                }
            })
            .onReceive(speciesUpdater.$species, perform: { species in
                if !species.name.isEmpty {
                    voiceUpdater.species = species
                }
            })
            .onAppear {
                hideImage(in: size)
            }
            .onWillDisappear {
                isShowingImage = false
                voiceUpdater.refresh()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        })
    }
}

struct ButtonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isShowing: Bool
    @Binding var isInExpandeMode: Bool
    var pokemon: Pokemon
    var namespace: Namespace.ID
    
    @State var isFavorite = false
    
    var body: some View {
        HStack{
            Button {
                withAnimation(.spring()){
                    isShowing = false
                }
            } label: {
                Image(systemName: ("arrow.uturn.left"))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.clear)
                    .clipShape(Circle())
            }
            .frame(width: 50, height: 50, alignment: .center)
            Spacer()
            if !isInExpandeMode {
                Text(pokemon.name.capitalized)
                    .font(Biotif.bold(size: 25).font)
                    .fontWeight(.bold)
                    .foregroundColor(pokemon.mainType.color.text)
                    .background(Color.clear)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: pokemon.name, in: namespace)
                Spacer()
            }
            AnimatedLikeButton(isFavorite: $isFavorite)
                .padding()
                .background(Color.clear)
                .clipShape(Circle())
                .frame(width: 50, height: 50, alignment: .center)
        }
        .padding(.top, UIDevice().hasNotch ? 44 : 8)
        .padding(.horizontal)
    }
}

struct NameView: View {
    var pokemon: Pokemon
    var namespace: Namespace.ID
    
    @Binding var opacity: Double
    
    var body: some View {
        HStack(alignment: .lastTextBaseline){
            Text(pokemon.name.capitalized)
                .font(Biotif.bold(size: 35).font)
                .fontWeight(.bold)
                .foregroundColor(pokemon.mainType.color.text)
                .background(Color.clear)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .matchedGeometryEffect(id: pokemon.name, in: namespace)
            Spacer()
            Text(String(format: "#%03d", pokemon.pokeId))
                .font(Biotif.bold(size: 20).font)
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
                                    .fill(Color.white.opacity(0.5))
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
