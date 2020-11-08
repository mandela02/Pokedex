//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI
import CoreData

@main
struct PokedexApp: App {
    @StateObject var reachabilityUpdater = ReachabilityUpdater()
    var body: some Scene {
        WindowGroup {
            PrepareView()
                .environmentObject(reachabilityUpdater)
        }
    }
}

struct PrepareView: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    @StateObject var updater = SearchDataPrepareUpdater()
    var body: some View {
        ZStack {
            if reachabilityUpdater.hasNoInternet {
                NoInternetView()
            }
            MovingDot()
        }
        .onReceive(reachabilityUpdater.$retry, perform: { retry in
            if retry {
                updater.needRetry = retry
            }
        })
        .fullScreenCover(isPresented: $updater.isDone) {
            NavigationView {
                HomeView()
                    .statusBar(hidden: true)
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .environmentObject(reachabilityUpdater)
            }
        }.environment(\.managedObjectContext, PersistenceManager.shared.persistentContainer.viewContext)
        .statusBar(hidden: true)
        .showAlert(error: $updater.error)
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showBall = true
            }
        }.onWillDisappear {
            showBall = false
        }
    }
}
