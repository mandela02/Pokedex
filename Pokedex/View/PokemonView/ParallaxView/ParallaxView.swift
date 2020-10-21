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
                    }
                    if let url = url, url != "" {
                        updater.pokemonUrl = url
                    }
                    updater.isSelected = true
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
    @State private var index: Int = 1
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
                                .onChange(of: reader.frame(in: .global).minY - 100 + maxHeight, perform:  { y in
                                    opacity = 1 + Double(reader.frame(in: .global).minY/(maxHeight - 50))
                                    scale = 1 + CGFloat(reader.frame(in: .global).minY/(maxHeight - 50))
                                    imageOffsetY = reader.frame(in: .global).maxY + 100 - maxHeight * 4 / 5
                                    if y < 0 {
                                        withAnimation(.linear) { isMinimized = true }
                                    } else {
                                        withAnimation(.linear) { isMinimized = false }
                                    }
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
                    .frame(height: UIScreen.main.bounds.height - 50, alignment: .center)
                }
            }
            
            //Top Image view
            if isShowingImage {
                HeaderImageScrollView(index: $index,
                                      items: $updater.images,
                                      onScrolling: { gesture in
                                      }, onEndScrolling: { gesture in
                                        if index == updater.ids.endIndex - 1 {
                                            updater.currentId = updater.ids.last ?? 0
                                        } else if index == 0 {
                                            if updater.currentId != 1 {
                                                updater.currentId = updater.ids.first ?? 0
                                            }
                                        }
                                        index = 1
                                        updater.update(onSuccess: {})
                                      })
                    .frame(width: UIScreen.main.bounds.width * 1/2,
                           height: maxHeight * 2/3,
                           alignment: .center)
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .offset(y: imageOffsetY)
            }

            // Header View (name, type, etc...)
            HeaderView(isShowing: $isShowing, isInExpandeMode: $isMinimized, opacity: $opacity, pokemon: updater.pokemon)
            
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
