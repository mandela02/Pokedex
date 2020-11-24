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
        Button  {
            show = true
        } label: {
            content()
                .background(NavigationLink(destination: destination()
                                            .environment(\.managedObjectContext, PersistenceManager.shared.persistentContainer.viewContext),
                                           isActive: $show) { EmptyView() })
        }
        .background(Color.clear)
    }
}

struct PushOnSigalView<Destination: View>: View {
    @Binding var show: Bool
    
    var destination: () -> Destination
    var body: some View {
        NavigationLink(destination: destination()
                        .environment(\.managedObjectContext, PersistenceManager.shared.persistentContainer.viewContext),
                       isActive: $show) { EmptyView() }
    }
}

struct TapToPresentView<Content: View, Destination: View>: View {
    @Binding var show: Bool
    
    let content: () -> Content
    let destination: () -> Destination
    
    var body: some View {
        Button  {
            show = true
        } label: {
            content()
        }.sheet(isPresented: $show, content: {
            destination()
                .environment(\.managedObjectContext, PersistenceManager.shared.persistentContainer.viewContext)
        }).background(Color.clear)
    }
}
