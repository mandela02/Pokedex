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
    @StateObject var speciesUpdater: SpeciesUpdater = SpeciesUpdater(url: "")
    @State private var isExpanded = true
    @State private var isShowingImage = true
    @State private var offset = CGSize.zero
    @State private var opacity: Double = 1
    @State private var isFirstTimeLoadView = true
    @State private var isLoadingData = true

    init(pokemon: Pokemon? = Pokemon(), pokemonUrl: String? = nil, isShowing: Binding<Bool>) {
        self._isShowing = isShowing
        self.pokemon = pokemon
        self.url = pokemonUrl
    }

    var body: some View {
        ParallaxContentView(isShowing: $isShowing, voiceUpdater: voiceUpdater, updater: updater, speciesUpdater: speciesUpdater)
        .navigationTitle("")
        .navigationBarHidden(true)
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    voiceUpdater.isSpeaking = true
                    isLoadingData = false
                }
            }
        })
        .onAppear {
            if isFirstTimeLoadView {
                isLoadingData = true
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
    let maxHeight = UIScreen.main.bounds.height * 0.4 - 50
    
    @Binding var isShowing: Bool

    @State var isMinimized = false
    @State var colums = Array(repeating: GridItem(.flexible(), spacing: 15), count: 1)
    @State var index: Int = 1
    @State private var opacity: Double = 1
    
    @ObservedObject var voiceUpdater: VoiceHelper
    @ObservedObject var updater: PokemonUpdater
    @ObservedObject var speciesUpdater: SpeciesUpdater
    
    @Namespace private var namespace

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            updater.pokemon.mainType.color.background.ignoresSafeArea()
                .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
                .animation(.linear)
            if !isMinimized {
                RotatingPokeballView()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .bottom)
            } else {
                RotatingPokeballView()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width * 4/5,
                           height: UIScreen.main.bounds.height * 4/5,
                           alignment: .center)
                    .offset(x: UIScreen.main.bounds.width * 1/3, y: -UIScreen.main.bounds.height * 1/3 )
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    GeometryReader { reader -> AnyView in
                        return AnyView(
                        Color.clear
                                .onChange(of: reader.frame(in: .global).minY - 100 + maxHeight, perform:  { y in
                                    opacity = 1 + Double(reader.frame(in: .global).minY/(maxHeight - 50))

                                    if y < 0 {
                                        withAnimation(.linear) { isMinimized = true }
                                    } else {
                                        withAnimation(.linear) { isMinimized = false }
                                    }
                                })
                        )
                    }
                    .frame(height: maxHeight)
                    
                    VStack(spacing: 0) {
                        Spacer()
                        Color.white
                            .frame(height: 100, alignment: .center)
                            .cornerRadius(25)
                            .offset(y: 50)
                        DetailPageView(updater: speciesUpdater, pokemon: updater.pokemon)
                            .background(Color.white)
                    }
                    .frame(height: UIScreen.main.bounds.height - 50, alignment: .center)
                }
            }
            
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
                                    updater.update(onSuccess: {
                                    })
                                  })
                .frame(width: UIScreen.main.bounds.width * 1/2, height: maxHeight * 2/3, alignment: .center)
                .opacity(opacity)
                .offset(y: maxHeight/2 + 20 )

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

//            NewButtonView(isShowing: $isShowing, isInExpandeMode: $isMinimized, pokemon: updater.pokemon)
//                .ignoresSafeArea()
//                .opacity(isMinimized ? 1 : 0)
//                //.background(BackgroundView(isExpanded: $isMinimized, pokemon: updater.pokemon))
        })
    }
}

struct BackgroundView: View {
    @Binding var isExpanded: Bool
    var pokemon: Pokemon
    var body: some View {
        if isExpanded {
            pokemon.mainType.color.background.opacity(0.5).blur(radius: 3)
        } else {
            Color.clear
        }
    }
}

struct HeaderView: View {
    @Binding var isShowing: Bool
    @Binding var isInExpandeMode: Bool
    @Binding var opacity: Double

    var pokemon: Pokemon

    var body: some View {
        VStack {
            NewButtonView(isShowing: $isShowing, isInExpandeMode: $isInExpandeMode, pokemon: pokemon)
            NewNameView(pokemon: pokemon, opacity: $opacity)
            NewTypeView(pokemon: pokemon)
            Spacer()
        }
    }
}

struct NewButtonView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: []) var favorites: FetchedResults<Favorite>

    @Binding var isShowing: Bool
    @Binding var isInExpandeMode: Bool
    var pokemon: Pokemon
    
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
            if isInExpandeMode {
                Text(pokemon.name.capitalized)
                    .font(Biotif.bold(size: 25).font)
                    .fontWeight(.bold)
                    .foregroundColor(pokemon.mainType.color.text)
                    .background(Color.clear)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
                Spacer()
            }
            AnimatedLikeButton(isFavorite: $isFavorite, onTap: {
                if isFavorite {
                    like(pokemon: pokemon)
                } else {
                    dislike(pokemon: pokemon)
                }
            })
                .padding()
                .background(Color.clear)
                .clipShape(Circle())
                .frame(width: 50, height: 50, alignment: .center)
        }
        .padding(.top, UIDevice().hasNotch ? 44 : 8)
        .padding(.horizontal)
        .onChange(of: pokemon.pokeId, perform: { id in
            if id != 0 {
                isFavorite = favorites.map({$0.url}).contains(UrlType.getPokemonUrl(of: id))
            }
        })
        .onAppear {
            if pokemon.pokeId != 0 {
                isFavorite = favorites.map({$0.url}).contains(UrlType.getPokemonUrl(of: pokemon.pokeId))
            }
        }
    }
    
    private func like(pokemon: Pokemon) {
        let favorite = Favorite(context: viewContext)
        favorite.url = UrlType.getPokemonUrl(of: pokemon.pokeId)
        save()
    }
    
    private func dislike(pokemon: Pokemon) {
        guard let item = favorites.first(where: {$0.url == UrlType.getPokemonUrl(of: pokemon.pokeId)}) else {
            return
        }
        viewContext.delete(item)
        save()
    }
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct NewNameView: View {
    var pokemon: Pokemon
    
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
                .opacity(opacity)
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

struct NewTypeView: View {
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
