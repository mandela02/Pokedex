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
            updater.selectedLocation = regionModel.name.capitalizingFirstLetter()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct LocationPickerView: View {
    @ObservedObject var updater: RegionDetailUpdater
 
    var selectedLocationLabel: some View {
        Text(updater.selectedLocation)
            .font(Biotif.bold(size: 20).font)
            .foregroundColor(.blue)
    }
    
    var selectedPokedexLabel: some View {
        Text(updater.selectedPokedex)
            .font(Biotif.bold(size: 20).font)
            .foregroundColor(.blue)
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Location")
                    .font(Biotif.regular(size: 20).font)
                    .foregroundColor(.black)
                Spacer()
                Picker(selection: $updater.selectedLocation,
                       label: selectedLocationLabel) {
                    ForEach(updater.locations) {
                        Text($0)
                    }
                }.pickerStyle(MenuPickerStyle())
            }.frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            
            if updater.isHavingMultiDex {
                HStack {
                    Text("Pokedex")
                        .font(Biotif.regular(size: 20).font)
                        .foregroundColor(.black)
                    Spacer()
                    Picker(selection: $updater.selectedPokedex,
                           label: selectedPokedexLabel) {
                        ForEach(updater.pokedexNames) {
                            Text($0)
                        }
                    }.pickerStyle(MenuPickerStyle())
                }.frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            }
        }
        .transition(.opacity)
        .animation(Animation.easeIn(duration: 0.2))
    }
}
