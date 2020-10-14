//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

@main
struct PokedexApp: App {
    @State var show = false
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .fullScreenCover(isPresented: $show) {
                    NavigationView {
                        HomeView()
                            .statusBar(hidden: true)
                            .environmentObject(VoiceHelper())
                            .navigationTitle("")
                            .navigationBarHidden(true)
                    }
                }
                .statusBar(hidden: true)
                .onAppear {
                    show = true
                }
        }
    }
}

struct HomeView: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry  in
                let size = geometry.size
                
                RotatingPokeballView(color: .red)
                    .ignoresSafeArea()
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .offset(x: size.width * 1/4 + 25, y: -size.height * 2/5)

                PokedexView()
                    .ignoresSafeArea()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)

            }
        }
    }
}
