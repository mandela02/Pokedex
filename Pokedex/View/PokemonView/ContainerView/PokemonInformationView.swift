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
    @State private var isLoadingData = true

    @State var index: Int = 1
    @State var isScrollable: Bool = false
    @Namespace private var namespace
    
    init(updater: PokemonUpdater? = nil, pokemonUrl: String? = nil, isShowing: Binding<Bool>) {
        if let updater = updater {
            self.updater = updater
        } else {
            let newUpdater = PokemonUpdater(url: pokemonUrl ?? "")
            newUpdater.isSelected = true
            self.updater = newUpdater
        }
        self._isShowing = isShowing
    }
    
    private var safeAreaOffset: CGFloat {
        return UIDevice().hasNotch ? 0 : 120
    }
    
    private func drag(in size: CGSize) -> some Gesture {
        return DragGesture()
            .onChanged({ gesture in
                onGestureScrolling(gesture: gesture, size: size)
            }).onEnded({ gesture in
                onGestureEnd(gesture: gesture, size: size)
            })
    }
    
    private func onGestureScrolling(gesture: DragGesture.Value, size: CGSize) {
        if abs(gesture.translation.height) > 50 {
            let collapseValue = size.height / 4 - 100
            let direction = Direction.getDirection(value: gesture)
            if direction == .down || direction == .up {
                withAnimation(.spring()) {
                    self.offset = gesture.translation
                    opacity = 1 + Double(offset.height/collapseValue)
                    hideImage(in: size)
                }
            }
        }
    }
    
    private func onGestureEnd(gesture: DragGesture.Value, size: CGSize) {
        let direction = Direction.getDirection(value: gesture)
        if direction == .down || direction == .up {
            withAnimation(.spring()) {
                updateView(with: size)
            }
        }
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
                    HeaderImageScrollView(index: $index,
                                          items: $updater.images,
                                          isScrollable: $isScrollable,
                                          onScrolling: { gesture in
                                            onGestureScrolling(gesture: gesture, size: size)
                                          }, onEndScrolling: { gesture in
                                            if index == updater.ids.endIndex - 1 {
                                                updater.currentId = updater.ids.last ?? 0
                                            } else if index == 0 {
                                                if updater.currentId != 1 {
                                                    updater.currentId = updater.ids.first ?? 0
                                                }
                                            }
                                            index = 1
                                            onGestureEnd(gesture: gesture, size: size)
                                            updater.update(onSuccess: {
                                                isLoadingData = true
                                                isScrollable = false
                                            })
                                          })
                        .frame(width: size.width * 1/2, height: size.height * 1/4, alignment: .center)
                        .offset(y: -size.width/2 + 30)
                        .opacity(opacity)
                        .gesture(drag(in: size))
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
                    }
                }
                
                if isLoadingData {
                    LoadingView()
                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                }
            }
            .ignoresSafeArea()
            .onReceive(updater.$pokemon, perform: { pokemon in
                if speciesUpdater.speciesUrl != pokemon.species.url {
                    speciesUpdater.speciesUrl = pokemon.species.url
                    voiceUpdater.pokemon = pokemon
                }
            })
            .onReceive(speciesUpdater.$species, perform: { species in
                if species.id != 0 {
                    voiceUpdater.species = species
                    isScrollable = true
                    isLoadingData = false
                    voiceUpdater.isSpeaking = true
                }
            })
            .onAppear {
                if isFirstTimeLoadView {
                    isLoadingData = true
                }
                hideImage(in: size)
                if isFirstTimeLoadView {
                    isFirstTimeLoadView = false
                }
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
