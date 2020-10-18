//
//  TapToPushView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import SwiftUI

struct TapToPushView<Content: View, Destination: View>: View {
    @Binding var show: Bool
    
    let content: () -> Content
    let destination: () -> Destination
    
    var body: some View {
        Button {
            show = true
        } label: {
            content()
                .background(NavigationLink(destination: destination(),
                                           isActive: $show) { EmptyView() })
        }
    }
}

struct PushOnSigalView<Destination: View>: View {
    @Binding var show: Bool
    
    var destination: () -> Destination
    var body: some View {
        NavigationLink(destination: destination(),
                       isActive: $show) { EmptyView() }
    }
}
