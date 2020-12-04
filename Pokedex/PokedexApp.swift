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


struct ContentViewExample: View {
    @State private var offset = CGSize.zero
    @State private var isDragging = false

    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in self.offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    self.offset = .zero
                    self.isDragging = false
                }
            }
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    self.isDragging = true
                }
            }
        let combined = pressGesture.sequenced(before: dragGesture)
        
        return Circle()
            .fill(Color.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)
    }
}

struct GestureExample: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .onTapGesture {
                    print("Text tapped")
                }
        }
        .highPriorityGesture(
            TapGesture()
                .onEnded { _ in
                    print("VStack tapped")
                }
        )
    }
}
