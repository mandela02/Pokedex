//
//  ParalaxView.swift
//  Pokedex
//
//  Created by TriBQ on 20/10/2020.
//

import SwiftUI

struct ParallaxView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    
    @Binding var isShowing: Bool
    var pokedexCellModel: PokedexCellModel?
    
    @StateObject var voiceUpdater: VoiceHelper = VoiceHelper()
    @StateObject var updater: PokemonUpdater = PokemonUpdater()
    
    @State private var isFirstTimeLoadView = true
    @State private var isMinimized = false
    @State private var opacity: Double = 1
    @State private var showLikedNotification: Bool = false
    
    init(pokedexCellModel: PokedexCellModel, isShowing: Binding<Bool>) {
        self._isShowing = isShowing
        self.pokedexCellModel = pokedexCellModel
    }
    
    var body: some View {
        ZStack {
            updater.pokemonModel.pokemon.mainType.color.background
                .ignoresSafeArea()
                .animation(.linear)
            
            GeometryReader(content: { geometry in
                RotatingPokeballView()
                    .ignoresSafeArea()
                    .frame(width: geometry.size.width * 4/5,
                           height: geometry.size.height * 4/5,
                           alignment: .center)
                    .offset(x: geometry.size.width * 1/3,
                            y: -geometry.size.height * 1/3 )
                    .isRemove(!isMinimized)
                    .blur(radius: showLikedNotification ? 3 : 0)
                
                if updater.isTopView {
                    RotatingPokeballView()
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width,
                               height: geometry.size.height,
                               alignment: .bottom)
                        .isRemove(isMinimized)
                        .blur(radius: showLikedNotification ? 3 : 0)
                }
                
                ParallaxContentView(height: geometry.size.height,
                                    width: geometry.size.width,
                                    isShowing: $isShowing,
                                    isMinimized: $isMinimized,
                                    opacity: $opacity,
                                    updater: updater)
                    .blur(radius: showLikedNotification ? 3 : 0)
                    .clipped()
            })
            
            PulsatingPlayButton(isSpeaking: $voiceUpdater.isSpeaking,
                                about: updater.pokemonModel.pokemon)
                .padding(.trailing, 30)
                .padding(.bottom, 30)
                .transition(.opacity)
                .blur(radius: showLikedNotification ? 3 : 0)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity,
                   alignment: .bottomTrailing)
            
            PokemonHeaderView(isShowing: $isShowing,
                              isInExpandeMode: $isMinimized,
                              opacity: $opacity,
                              showLikedNotification: $showLikedNotification,
                              isDisabled: $updater.isLoadingInitialData,
                              pokemon: updater.pokemonModel.pokemon)
                .blur(radius: updater.isLoadingNewData ? 3 : 0)
                .blur(radius: showLikedNotification ? 3 : 0)
            
            if showLikedNotification {
                LikedNotificationView(id: updater.pokemonModel.pokemon.pokeId,
                                      name: updater.pokemonModel.pokemon.name,
                                      image: updater.pokemonModel.pokemon.sprites.other?.artwork.front ?? "")
                    .animation(.default)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .onChange(of: showLikedNotification, perform: { showLikedNotification in
            if showLikedNotification == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.default) {
                        self.showLikedNotification = false
                    }
                }
            }
        }).onReceive(updater.$pokemonModel, perform: { pokemonModel in
            voiceUpdater.pokemon = pokemonModel.pokemon
            if pokemonModel.species.id != 0 {
                voiceUpdater.species = pokemonModel.species
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    voiceUpdater.isSpeaking = true
                }
            }
        }).onReceive(reachabilityUpdater.$retry, perform: { retry in
            updater.retry = retry
        }).onAppear {
            updater.isTopView = true
            if isFirstTimeLoadView {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let model = pokedexCellModel, !model.isEmpty {
                        updater.initPokedexCellModel(model: model)
                    }
                }
            }
            if isFirstTimeLoadView {
                isFirstTimeLoadView = false
            }
        }.onWillDisappear({
            updater.isTopView = false
            voiceUpdater.refresh()
        }).showAlert(error: $updater.error)
    }
}

struct ParallaxContentView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    
    var height: CGFloat
    var width: CGFloat

    @Binding var isShowing: Bool
    @Binding var isMinimized: Bool
    @Binding var opacity: Double
    
    @State private var scale: CGFloat = 1
    @State private var imageOffsetY: CGFloat = 1
    @State private var maxHeight: CGFloat = 0
    @State private var backgroundHeight: CGFloat = 0
    
    @ObservedObject var updater: PokemonUpdater
    
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            VStack() {
                Spacer()
                Group {
                    isDarkMode ? Color.black : Color.white
                }.frame(height: backgroundHeight, alignment: .bottom)
            }


            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    GeometryReader { reader -> AnyView in
                        let minFrameY = reader.frame(in: .named("ContainerView")).minY
                        let maxFrameY = reader.frame(in: .named("ContainerView")).maxY
                        
                        DispatchQueue.main.async {
                            backgroundHeight = height * 1/2 - maxFrameY > 0 ? height * 1/2 - maxFrameY : 0
                            imageOffsetY = maxFrameY + 100 - maxHeight * 4 / 5
                            let frameY = minFrameY - 100 + maxHeight
                            
                            opacity = 1 + Double(minFrameY/(maxHeight - 50))
                            scale = 1 + CGFloat(minFrameY/(maxHeight - 50))
                            
                            if frameY <= 0 {
                                withAnimation(.linear) { isMinimized = true }
                            } else {
                                withAnimation(.linear) { isMinimized = false }
                            }
                        }
                        return AnyView(Color.clear)
                    }.frame(height: maxHeight)
                    
                    VStack(spacing: 0) {
                        Spacer()
                        if isDarkMode {
                            Color.black
                                .frame(height: 100, alignment: .center)
                                .cornerRadius(25)
                                .offset(y: 50)
                        } else {
                            Color.white
                                .frame(height: 100, alignment: .center)
                                .cornerRadius(25)
                                .offset(y: 50)
                        }
                        DetailPageView(species: updater.pokemonModel.species,
                                       pokemon: updater.pokemonModel.pokemon)
                            .background(isDarkMode ? Color.black : Color.white)
                    }
                    .blur(radius: updater.isLoadingNewData ? 3 : 0)
                    .frame(height: height - 50, alignment: .center)
                    
                    Spacer()
                }
            }
            
            if !updater.isLoadingInitialData {
                if updater.pokemonModel.pokemon.isDefault {
                    HeaderImageScrollView(index: $updater.currentScrollIndex,
                                          isAllowScroll: $updater.isAllowScroll,
                                          items: updater.images,
                                          onEndScrolling: { direction in
                                            updater.moveTo(direction: direction)
                                          })
                        .frame(width: width * 1/2,
                               height: maxHeight * 2/3,
                               alignment: .center)
                        .opacity(opacity)
                        .scaleEffect(scale)
                        .offset(y: imageOffsetY)
                        .disabled(reachabilityUpdater.hasNoInternet)
                } else {
                    DownloadedImageView(withURL: updater.pokemonModel.pokemon.sprites.other?.artwork.front ?? "", style: .animated)
                        .scaleEffect(1.5)
                        .frame(width: width,
                               height: maxHeight * 2/3,
                               alignment: .center)
                        .opacity(opacity)
                        .scaleEffect(scale)
                        .offset(y: imageOffsetY)
                }
            }
        }).onAppear(perform: {
            maxHeight = height * 0.4 - 50
        })
        .coordinateSpace(name: "ContainerView")
    }
}
