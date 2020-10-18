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
    @State var show = true
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .fullScreenCover(isPresented: $show) {
                    NavigationView {
                        HomeView()
                            .statusBar(hidden: true)
                            .navigationTitle("")
                            .navigationBarHidden(true)
                    }
                }.environment(\.managedObjectContext, PersistenceManager.shared.persistentContainer.viewContext)
                .statusBar(hidden: true)
        }
    }
}

struct HomeView: View {
    @State var showBall: Bool = true

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
            showBall = true
        }
        .onWillDisappear {
            showBall = false
        }

    }
}

class PersistenceManager {
    static let shared = PersistenceManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokemonModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {
        let center = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification
        center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            if self.persistentContainer.viewContext.hasChanges {
                try? self.persistentContainer.viewContext.save()
            }
        }
    }
}
