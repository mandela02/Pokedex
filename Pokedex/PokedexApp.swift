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
    @StateObject var errorHandler = ErrorHandler()

    var body: some Scene {
        WindowGroup {
            PrepareView().environmentObject(errorHandler)
        }
    }
}

struct PrepareView: View {
    @EnvironmentObject var errorHandler: ErrorHandler
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
            .environmentObject(errorHandler)
            .onAppear {
                updater.errorHandler = errorHandler
            }.statusBar(hidden: true)
            .showAlertIfCallApiFail()
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
