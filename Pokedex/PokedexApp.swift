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
    var body: some Scene {
        WindowGroup {
            PrepareView()
                .onAppear {
                    do {
                        try Network.reachability = Reachability(hostname: "www.google.com")
                    }
                    catch {
                        switch error as? Network.Error {
                        case let .failedToCreateWith(hostname)?:
                            print("Network error:\nFailed to create reachability object With host named:", hostname)
                        case let .failedToInitializeWith(address)?:
                            print("Network error:\nFailed to initialize reachability object With address:", address)
                        case .failedToSetCallout?:
                            print("Network error:\nFailed to set callout")
                        case .failedToSetDispatchQueue?:
                            print("Network error:\nFailed to set DispatchQueue")
                        case .none:
                            print(error)
                        }
                    }
                }
        }
    }
}

struct PrepareView: View {
    @StateObject var updater = SearchDataPrepareUpdater()

    var body: some View {
        EmptyView()
            .fullScreenCover(isPresented: $updater.isDone) {
                NavigationView {
                    HomeView()
                        .statusBar(hidden: true)
                        .navigationTitle("")
                        .navigationBarHidden(true)
                }
            }.environment(\.managedObjectContext, PersistenceManager.shared.persistentContainer.viewContext)
            .statusBar(hidden: true)
            .showErrorView(error: $updater.error)
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
