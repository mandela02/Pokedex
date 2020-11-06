//
//  ParalaxView.swift
//  Pokedex
//
//  Created by TriBQ on 20/10/2020.
//

import SwiftUI

struct ParallaxView: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater

    @Binding var isShowing: Bool
    var url: String?
        
    @StateObject var voiceUpdater: VoiceHelper = VoiceHelper()
    @StateObject var updater: PokemonUpdater = PokemonUpdater()
    
    @State private var isShowingImage = true
    @State private var isFirstTimeLoadView = true
    @State private var isMinimized = false
    @State private var opacity: Double = 1
    @State private var showLikedNotification: Bool = false

    init(pokemonUrl: String, isShowing: Binding<Bool>) {
        self._isShowing = isShowing
        self.url = pokemonUrl
    }
    
    var body: some View {
        ZStack {
            updater.pokemon.mainType.color.background.ignoresSafeArea()
                .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
                .animation(.linear)
            
            if isShowingImage {
                RotatingPokeballView()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width * 4/5,
                           height: UIScreen.main.bounds.height * 4/5,
                           alignment: .center)
                    .offset(x: UIScreen.main.bounds.width * 1/3,
                            y: -UIScreen.main.bounds.height * 1/3 )
                    .isRemove(!isMinimized)
                    .blur(radius: showLikedNotification ? 3 : 0)
                
                RotatingPokeballView()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height,
                           alignment: .bottom)
                    .isRemove(isMinimized)
                    .blur(radius: showLikedNotification ? 3 : 0)
            }

            ParallaxContentView(isShowing: $isShowing,
                                isShowingImage: $isShowingImage,
                                isMinimized: $isMinimized,
                                opacity: $opacity,
                                updater: updater)
                .blur(radius: showLikedNotification ? 3 : 0)

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
            }.blur(radius: showLikedNotification ? 3 : 0)
            
            PokemonParallaxHeaderView(isShowing: $isShowing,
                                      isInExpandeMode: $isMinimized,
                                      opacity: $opacity,
                                      showLikedNotification: $showLikedNotification,
                                      pokemon: updater.pokemon)
                .blur(radius: updater.isLoadingNewData ? 3 : 0)
                .blur(radius: showLikedNotification ? 3 : 0)
            
            
            if showLikedNotification {
                LikedNotificationView(id: updater.pokemon.pokeId, name: updater.pokemon.name, image: updater.pokemon.sprites.other?.artwork.front ?? "")
                    .transition(.opacity)
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
        }).onReceive(updater.$pokemon, perform: { pokemon in
            voiceUpdater.pokemon = pokemon
        }).onReceive(updater.$species, perform: { species in
            if species.id != 0 {
                voiceUpdater.species = species
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    voiceUpdater.isSpeaking = true
                }
            }
        }).onReceive(reachabilityUpdater.$retry, perform: { retry in
            updater.retry = retry
        }).onAppear {
            isShowingImage = true
            updater.isTopView = true
            if isFirstTimeLoadView {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let url = url, url != "" {
                        updater.pokemonUrl = url
                    }
                }
            }
            if isFirstTimeLoadView {
                isFirstTimeLoadView = false
            }
        }.onWillDisappear({
            updater.isTopView = false
            isShowingImage = false
            voiceUpdater.refresh()
        }).showAlert(error: $updater.error)
    }
}

struct ParallaxContentView: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater

    private let maxHeight = UIScreen.main.bounds.height * 0.4 - 50
    
    @Binding var isShowing: Bool
    @Binding var isShowingImage: Bool
    @Binding var isMinimized: Bool
    @Binding var opacity: Double
    
    @State private var scale: CGFloat = 1
    @State private var imageOffsetY: CGFloat = 1

    @ObservedObject var updater: PokemonUpdater
        
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    GeometryReader { reader in
                            Color.clear
                                .onChange(of: reader.frame(in: .global).minY, perform:  { minFrameY in
                                    let frameY = minFrameY - 100 + maxHeight
                                    
                                    opacity = 1 + Double(minFrameY/(maxHeight - 50))
                                    scale = 1 + CGFloat(minFrameY/(maxHeight - 50))
                                    imageOffsetY = reader.frame(in: .global).maxY + 100 - maxHeight * 4 / 5
                                    
                                    if frameY <= 0 {
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
                    }.frame(height: maxHeight)
                    
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
            
            if updater.pokemon.isDefault {
                HeaderImageScrollView(index: $updater.currentScrollIndex,
                                      items: updater.images,
                                      onEndScrolling: { direction in
                                        updater.moveTo(direction: direction)
                                      })
                    .frame(width: UIScreen.main.bounds.width * 1/2,
                           height: maxHeight * 2/3,
                           alignment: .center)
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .offset(y: imageOffsetY)
                    .isRemove(!isShowingImage)
                    .disabled(reachabilityUpdater.hasNoInternet)
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
        })
    }
}
