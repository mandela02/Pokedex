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
        VStack {
            HStack {
                BackButtonView(isShowing: $isShowing)
                Spacer()
            }.padding(.top, 30)
            .padding(.leading, 20)
            
            Text("The region of " + regionModel.name.capitalizingFirstLetter())
                .font(Biotif.extraBold(size: 30).font)
                .foregroundColor(.black)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 35)

            RegionContentView(updater: updater)
        }
        .onAppear {
            updater.url = regionModel.url
            updater.selectedLocation = regionModel.name.capitalizingFirstLetter()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct RegionContentView: View {
    @ObservedObject var updater: RegionDetailUpdater
    
    var body: some View {
        VStack(spacing: 0) {
            LocationPickerView(updater: updater)
            ZStack {
                ScrollView(content: {
                    Color.clear.frame(height: 10)
                    ParallaxPokemonsList(pokemons: updater.pokedexCellModels)
                    Color.clear.frame(height: 10)
                })
                VStack {
                    Spacer()
                    GradienView(atTop: false).frame(height: 50)
                }
            }
        }
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
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}
