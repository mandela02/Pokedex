//
//  RegionDetailView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 20/11/2020.
//

import SwiftUI

struct RegionDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var updater = RegionDetailUpdater()
    
    var regionModel: RegionCellModel
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            CustomBigTitleNavigationView(content: {
                LocationPickerView(updater: updater)
            }, header: {
                BigTitle(text: "The region of " + regionModel.name.capitalizingFirstLetter())
            }, stickyHeader: {
                NamedHeaderView(name: regionModel.name.capitalizingFirstLetter())
            }, maxHeight: 150)

            VStack {
                HStack(alignment: .center) {
                    BackButtonView(isShowing: $isShowing)
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 30)
            .padding(.leading, 20)
        }
        .onAppear {
            updater.url = regionModel.url
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct LocationPickerView: View {
    @ObservedObject var updater: RegionDetailUpdater
    
    var body: some View {
        Form {
            Picker(selection: $updater.selectedLocation, label: Text("Location")) {
                ForEach(updater.region?.locations.map({$0.name.capitalizingFirstLetter().eliminateDash}) ?? []) {
                    Text($0)

                }
            }
        }.frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 100, alignment: .center)
    }
}
