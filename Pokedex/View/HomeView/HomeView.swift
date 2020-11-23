//
//  HomeView.swift
//  Pokedex
//
//  Created by TriBQ on 18/11/2020.
//

import SwiftUI


struct EmptyPresentView: View {
    var body: some View {
        EmptyView()
            .fullScreenCover(isPresented: .constant(true)) {
                PrepareView()
            }.statusBar(hidden: true)
    }
}

struct PrepareView: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    @State var isShowPrepareView = false
    
    var body: some View {
        NavigationView {
            HomeView()
                .statusBar(hidden: true)
                .navigationTitle("")
                .navigationBarHidden(true)
        }
        .isRemove(isShowPrepareView)
        .environment(\.managedObjectContext, PersistenceManager.shared.persistentContainer.viewContext)
        .fullScreenCover(isPresented: $isShowPrepareView) {
            CheckingView(isPresented: $isShowPrepareView)
                .environmentObject(reachabilityUpdater)
        }.onAppear {
            isShowPrepareView = true
        }.statusBar(hidden: true)
    }
}

struct HomeView: View {
    @State var showBall: Bool = false

    var body: some View {
        ZStack {
            GeometryReader { geometry  in
                let size = geometry.size
                if showBall {
                    RotatingPokeballView(color: .red)
                        .ignoresSafeArea()
                        .frame(width: size.width, height: size.height, alignment: .center)
                        .offset(x: size.width * 1/4 + 25, y: -size.height * 2/5)
                }
                NavigationPokedexView()
            }
        }
        .statusBar(hidden: true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showBall = true
            }
        }.onWillDisappear {
            showBall = false
        }
    }
}

struct CheckingView: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    @StateObject var updater = SearchDataPrepareUpdater()
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            if reachabilityUpdater.hasNoInternet {
                NoInternetView()
            }
            SplashScreen()
        }
        .onReceive(reachabilityUpdater.$retry, perform: { retry in
            if retry {
                updater.needRetry = retry
            }
        })
        .onReceive(updater.$isDone, perform: { isDone in
            if isDone {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                }
            }
        })
        .showAlert(error: $updater.error)
    }
}

struct SplashScreen: View {
    let conic = RadialGradient(gradient: Gradient(colors: [Color.red.opacity(0.5),
                                                           Color.red]),
                               center: .center,
                               startRadius: 100,
                               endRadius: 300)

    var body: some View {
        ZStack {
            conic
            RotatingPokemonView(image: "icon", background: .clear)
            VStack(spacing: 5) {
                Spacer()
                Text("POKEDEX")
                    .font(Biotif.extraBold(size: 30).font)
                    .foregroundColor(.white)
                HStack(alignment: .center, spacing: 10, content: {
                    Spacer()
                    PokemonIcon(name: "bullbasaur")
                    PokemonIcon(name: "charmander")
                    PokemonIcon(name: "squirtle")
                    PokemonIcon(name: "pikachu")
                    PokemonIcon(name: "meowth")
                    Spacer()
                })
            }.padding(.bottom, 100)
        }.ignoresSafeArea()
    }
}

struct PokemonIcon: View {
    var name: String
    
    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 20, height: 20, alignment: .center)
    }
}
