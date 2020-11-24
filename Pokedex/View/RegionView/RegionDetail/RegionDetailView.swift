//
//  RegionDetailView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 20/11/2020.
//

import SwiftUI
import Combine

struct RegionDetailView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var updater = RegionDetailUpdater()
    @State private var isFirstTime = true
    @State private var keyboardHeight: CGFloat = 0
    @State var isShowSearchBar: Bool = false


    var regionModel: RegionCellModel
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            RegionNavigation(isShowing: $isShowing,
                             updater: updater,
                             isShowSearchBar: $isShowSearchBar)
            
            GeometryReader (content: { geometry in
                ZStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("The region of " + regionModel.name.capitalizingFirstLetter())
                            .font(Biotif.extraBold(size: 30).font)
                            .foregroundColor(isDarkMode ? Color.black : Color.white)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 35)

                        RegionContentView(updater: updater)
                    }

                    if updater.searchValue != "" {
                        ScrollView {
                            ForEach(updater.searchResult) { result in
                                Button(action: {
                                    withAnimation {
                                        updater.selectedLocation = result
                                        isShowSearchBar = false
                                        updater.searchValue = ""
                                    }
                                }, label: {
                                    Text(result.capitalizingFirstLetter())
                                        .font(Biotif.medium(size: 15).font)
                                        .foregroundColor( isDarkMode ? .white : .black)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                                        .padding(.leading, 10)
                                })
                                .frame(height: 44.0)
                                .background(isDarkMode ? Color.black : Color.white)
                                .padding(.leading, 10)
                            }
                        }
                        .frame(height: geometry.size.height - keyboardHeight, alignment: .center)
                    }
                }
            })
            
        }
        .background(isDarkMode ? Color.black : Color.white)
        .onReceive(Publishers.keyboardHeight, perform: {
            keyboardHeight = $0
        })
        .onAppear {
            if isFirstTime {
                updater.url = regionModel.url
                updater.selectedLocation = regionModel.name.capitalizingFirstLetter()
                isFirstTime = false
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct RegionNavigation: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @Binding var isShowing: Bool
    @ObservedObject var updater: RegionDetailUpdater
    @Binding var isShowSearchBar: Bool
    var placeholder = "Search Location"
    
    @Namespace var namespace
    var keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    var keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

    var body: some View {
        HStack {
            Button {
                withAnimation(.spring()){
                    isShowing = false
                }
            } label: {
                Image(systemName: ("arrow.uturn.left"))
                    .renderingMode(.template)
                    .foregroundColor(isDarkMode ? Color.white : Color.black)
                    .padding()
                    .background(Color.clear)
                    .clipShape(Circle())
            }.frame(width: 50, height: 50, alignment: .center)
            
            ZStack {
                if isShowSearchBar {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.medium)
                            .foregroundColor(Color(.systemGray3))
                            .padding(3)
                            .matchedGeometryEffect(id: "magnifyingglass", in: namespace)
                        TextField(placeholder, text: $updater.searchValue)
                            .font(.system(size: 15))
                        if updater.searchValue != "" {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                                .foregroundColor(Color(.systemGray3))
                                .padding(3)
                                .onTapGesture {
                                    withAnimation {
                                        updater.searchValue = ""
                                    }
                                }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Capsule().fill(Color(.systemGray6)).padding(.all, -10))
                } else {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isShowSearchBar = true
                            }
                        }, label: {
                            Image(systemName: "magnifyingglass")
                                .renderingMode(.template)
                                .foregroundColor(isDarkMode ? Color.white : Color.black)
                                .padding()
                                .background(Color.clear)
                                .clipShape(Circle())
                        }).matchedGeometryEffect(id: "magnifyingglass", in: namespace)
                    }
                }
            }.padding()
        }.padding(.top, 30)
        .padding(.leading, 20)
        .frame(height: 100, alignment: .center)
        .onReceive(keyboardWillHide, perform: { _ in
            withAnimation {
                isShowSearchBar = false
                updater.searchValue = ""
            }
        }).background(isDarkMode ? Color.black : Color.white)
    }
}

struct RegionContentView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    @ObservedObject var updater: RegionDetailUpdater
    @Namespace var animation
    @State var isLoadingData = true
    @State var havingNoPokemons = false

    var body: some View {
        VStack(spacing: 2) {
            LocationPickerView(updater: updater)
            ZStack {
                ScrollView(content: {
                    Color.clear.frame(height: 10)
                    if updater.neededToShowDex {
                        ParallaxPokemonsList(pokemons: updater.pokedexCellModels)
                    } else {
                        RegionPokemonList(pokemons: updater.areaPokedexCellModels)
                    }
                    Color.clear.frame(height: 10)
                }).blur(radius: updater.isLoadingData ? 3.0 : 0.0)
                VStack {
                    Spacer()
                    GradienView(atTop: false).frame(height: 50)
                }
                if isLoadingData {
                    LoadingView(background: isDarkMode ? .black : .white)
                            .matchedGeometryEffect(id: "loading", in: animation)
                } else if havingNoPokemons {
                    RotatingPokemonView(message: "No Pokemon in this Area",
                                        background: isDarkMode ? .black : .white)
                            .matchedGeometryEffect(id: "loading", in: animation)
                }
            }
        }.onReceive(updater.$isLoadingData, perform: { isLoadingData in
            withAnimation(.easeIn) {
                self.isLoadingData = isLoadingData
            }
        })
        .onReceive(updater.$havingNoPokemons, perform: { havingNoPokemons in
            withAnimation(.easeOut) {
                self.havingNoPokemons = havingNoPokemons
            }
        })
    }
}

struct LocationPickerView: View {
    @ObservedObject var updater: RegionDetailUpdater
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var selectedLocationLabel: some View {
        Text(updater.selectedLocation)
            .font(Biotif.bold(size: 20).font)
            .foregroundColor(isDarkMode ? .white : .blue)
    }
    
    var selectedPokedexLabel: some View {
        Text(updater.selectedPokedex)
            .font(Biotif.bold(size: 20).font)
            .foregroundColor(isDarkMode ? .white : .blue)
    }
    
    var selectedAreaLabel: some View {
        Text(updater.selectedArea)
            .font(Biotif.bold(size: 20).font)
            .foregroundColor(isDarkMode ? .white : .blue)
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Location")
                    .font(Biotif.regular(size: 20).font)
                    .foregroundColor(isDarkMode ? .white : .black)
                Spacer()
                Picker(selection: $updater.selectedLocation,
                       label: selectedLocationLabel) {
                    ForEach(updater.locations) {
                        Text($0)
                    }
                }.pickerStyle(MenuPickerStyle())
            }.frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(isDarkMode ? Color.black : Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            .id(updater.selectedLocation)
            .animation(.easeIn)
            
            if updater.isHavingMultiDex {
                HStack {
                    Text("Pokedex")
                        .font(Biotif.regular(size: 20).font)
                        .foregroundColor(isDarkMode ? .white : .black)
                    Spacer()
                    Picker(selection: $updater.selectedPokedex,
                           label: selectedPokedexLabel) {
                        ForEach(updater.pokedexNames) {
                            Text($0)
                        }
                    }.pickerStyle(MenuPickerStyle())
                }.frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(isDarkMode ? Color.black : Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .id(updater.selectedPokedex)
                .animation(.easeIn)
            }
            
            if updater.isHavingMultiArea {
                HStack {
                    Text("Area")
                        .font(Biotif.regular(size: 20).font)
                        .foregroundColor(isDarkMode ? .white : .black)
                    Spacer()
                    Picker(selection: $updater.selectedArea,
                           label: selectedAreaLabel) {
                        ForEach(updater.areaNames) {
                            Text($0)
                        }
                    }.pickerStyle(MenuPickerStyle())
                }.frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(isDarkMode ? Color.black : Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .id(updater.selectedArea)
                .animation(.easeIn)
            }
        }
        .transition(.opacity)
        .animation(Animation.easeIn(duration: 0.2))
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct RegionPokemonList: View {
    var pokemons: [AreaPokedexCellModel]
    
    let numberOfColumns: CGFloat = Constants.deviceIdiom == .pad ? 3 : 2
    
    var width: CGFloat {
        return (UIScreen.main.bounds.width - 80) / numberOfColumns
    }
    var height: CGFloat {
        width * 0.7
    }
    
    private func calculateGridItem() -> [GridItem] {
        let gridItem = GridItem(.fixed(width), spacing: 10)
        return Array(repeating: gridItem, count: Int(numberOfColumns))
    }
    
    var body: some View {
        LazyVGrid(columns: calculateGridItem()) {
            ForEach(pokemons) { cell in
                TappableRegionPokemonCell(pokedexCellModel: cell,
                                          size: CGSize(width: width, height: height))
                    .background(Color.clear)
            }
        }.animation(.linear)
    }
}

struct TappableRegionPokemonCell: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: []) var favorites: FetchedResults<Favorite>
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    
    @State var present: Bool = false
    @State var show: Bool = false
    @State var isFavorite = false

    let pokedexCellModel: AreaPokedexCellModel
    let size: CGSize
    
    var body: some View {
        TapToPresentView(show: $present) {
            PokedexCardView(url: pokedexCellModel.pokemonUrl, size: size)
                .contextMenu(menuItems: {
                    Button (action: {
                        show = true
                    }, label: {
                        Text("Detail File ...")
                    })
                    Button(action: {
                        if isFavorite {
                            CoreData.dislike(pokemon: pokedexCellModel.pokemonUrl)
                        } else {
                            CoreData.like(pokemon: pokedexCellModel.pokemonUrl)
                        }
                    }) {
                        Text(isFavorite ? "Remove from favorite" : "Add To favorite")
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                    }
                })
        } destination: {
            PokemonEncounterNavigationView(encounter: pokedexCellModel)
                .environmentObject(reachabilityUpdater)
        }.buttonStyle(PlainButtonStyle())
        .onAppear(perform: {
            isFavorite = favorites.map({$0.url}).contains(pokedexCellModel.pokemonUrl)
        }).onChange(of: favorites.count, perform: { value in
            isFavorite = favorites.map({$0.url}).contains(pokedexCellModel.pokemonUrl)
        }).background(NavigationLink(
                        destination: ParallaxView(pokedexCellModel: PokedexCellModel(pokemonUrl: pokedexCellModel.pokemonUrl, speciesUrl: pokedexCellModel.speciesUrl),
                                                  isShowing: $show)
                            .environmentObject(reachabilityUpdater),
                        isActive: $show,
                        label: {
                            EmptyView()
                        }))
    }
}
