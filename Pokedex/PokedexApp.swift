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
            EmptyPresentView()
                .environmentObject(reachabilityUpdater)
                .preferredColorScheme(.light)
        }
    }
}
