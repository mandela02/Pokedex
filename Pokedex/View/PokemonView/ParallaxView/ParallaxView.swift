//
//  ParalaxView.swift
//  Pokedex
//
//  Created by TriBQ on 20/10/2020.
//

import SwiftUI

struct ParallaxView: View {
    @Binding var isShowing: Bool
    var pokemon: Pokemon?
    var url: String?
    @StateObject var voiceUpdater: VoiceHelper = VoiceHelper()
    @StateObject var updater: PokemonUpdater = PokemonUpdater(url: "")
    @State private var isShowingImage = true
    @State private var offset = CGSize.zero
    @State private var opacity: Double = 1
    @State private var isFirstTimeLoadView = true
    
    init(pokemon: Pokemon? = Pokemon(), pokemonUrl: String? = nil, isShowing: Binding<Bool>) {
        self._isShowing = isShowing
        self.pokemon = pokemon
        self.url = pokemonUrl
    }
    
    var body: some View {
        ParallaxContentView(isShowing: $isShowing,
                            isShowingImage: $isShowingImage,
                            voiceUpdater: voiceUpdater,
                            updater: updater)
            .navigationTitle("")
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .onReceive(updater.$pokemon, perform: { pokemon in
                voiceUpdater.pokemon = pokemon
            })
            .onReceive(updater.$species, perform: { species in
                if species.id != 0 {
                    voiceUpdater.species = species
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        voiceUpdater.isSpeaking = true
                    }
                }
            })
            .onAppear {
                isShowingImage = true
                
                if isFirstTimeLoadView {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let pokemon = pokemon, pokemon.pokeId != 0 {
                            updater.pokemon = pokemon
                        } else if let url = url, url != "" {
                            updater.pokemonUrl = url
                        }
                    }
                }
                if isFirstTimeLoadView {
                    isFirstTimeLoadView = false
                }
            }
            .onWillDisappear {
                isShowingImage = false
                voiceUpdater.refresh()
            }
    }
}

struct ParallaxContentView: View {
    private let maxHeight = UIScreen.main.bounds.height * 0.4 - 50
    
    @Binding var isShowing: Bool
    @Binding var isShowingImage: Bool
    
    @State private var isMinimized = false
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 1
    @State private var imageOffsetY: CGFloat = 1
    
    @ObservedObject var voiceUpdater: VoiceHelper
    @ObservedObject var updater: PokemonUpdater
    
    @Namespace private var namespace
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            updater.pokemon.mainType.color.background.ignoresSafeArea()
                .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
                .animation(.linear)
            
            // Rotatin Ball
            if isShowingImage {
                if isMinimized {
                    RotatingPokeballView()
                        .ignoresSafeArea()
                        .frame(width: UIScreen.main.bounds.width * 4/5,
                               height: UIScreen.main.bounds.height * 4/5,
                               alignment: .center)
                        .offset(x: UIScreen.main.bounds.width * 1/3,
                                y: -UIScreen.main.bounds.height * 1/3 + maxHeight / 4 )
                } else {
                    RotatingPokeballView()
                        .ignoresSafeArea()
                        .frame(width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height,
                               alignment: .bottom)
                }
            }
            
            //Detail View
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    GeometryReader { reader -> AnyView in
                        return AnyView(
                            Color.clear
                                .onChange(of: reader.frame(in: .global).minY, perform:  { minFrameY in
                                    let frameY = minFrameY - 100 + maxHeight
                                    opacity = 1 + Double(minFrameY/(maxHeight - 50))
                                    scale = 1 + CGFloat(minFrameY/(maxHeight - 50))
                                    imageOffsetY = reader.frame(in: .global).maxY + 100 - maxHeight * 4 / 5
                                    if frameY < 0 {
                                        withAnimation(.linear) { isMinimized = true }
                                    } else {
                                        withAnimation(.linear) {
                                            if isMinimized == true {
                                                isMinimized = false
                                            }
                                        }
                                    }
                                })
                                .onChange(of: reader.frame(in: .global).maxY, perform:  { maxFrameY in
                                    imageOffsetY = maxFrameY + 100 - maxHeight * 4 / 5
                                })
                                .onAppear {
                                    imageOffsetY = reader.frame(in: .global).maxY + 100 - maxHeight * 4 / 5
                                }
                        )
                    }
                    .frame(height: maxHeight)
                    
                    VStack(spacing: 0) {
                        Spacer()
                        Color.white
                            .frame(height: 100, alignment: .center)
                            .cornerRadius(25)
                            .offset(y: 50)
                        DetailPageView(species: updater.species,
                                       pokemon: updater.pokemon)
                            .background(Color.white)
                    }
                    .blur(radius: updater.isLoadingNewData ? 3 : 0)
                    .frame(height: UIScreen.main.bounds.height - 50, alignment: .center)
                }
            }
            
            //Top Image view
            if updater.pokemon.isDefault {
                if isShowingImage {
                    HeaderImageScrollView(index: $updater.currentScrollIndex,
                                          items: $updater.images,
                                          isScrollable: $updater.isScrollingEnable,
                                          onScrolling: { gesture in
                                          }, onEndScrolling: { gesture, direction in
                                            updater.moveTo(direction: direction)
                                          })
                        .frame(width: UIScreen.main.bounds.width * 1/2,
                               height: maxHeight * 2/3,
                               alignment: .center)
                        .opacity(opacity)
                        .scaleEffect(scale)
                        .offset(y: imageOffsetY)
                }
            } else {
                DownloadedImageView(withURL: updater.pokemon.sprites.other?.artwork.front ?? "", style: .animated)
                    .scaleEffect(1.5)
                    .frame(width: UIScreen.main.bounds.width * 1/2,
                           height: maxHeight * 2/3,
                           alignment: .center)
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .offset(y: imageOffsetY)
            }
            
            // Header View (name, type, etc...)
            HeaderView(isShowing: $isShowing, isInExpandeMode: $isMinimized, opacity: $opacity, pokemon: updater.pokemon)
                .blur(radius: updater.isLoadingNewData ? 3 : 0)
            
            VStack() {
                Spacer()
                HStack {
                    Spacer()
                    PulsatingPlayButton(isSpeaking: $voiceUpdater.isSpeaking,
                                        about: $updater.pokemon)
                        .padding(.trailing, 30)
                        .padding(.bottom, 30)
                        .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
                }
            }
        })
    }
}
