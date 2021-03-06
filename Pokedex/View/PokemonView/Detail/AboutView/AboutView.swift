//
//  AboutView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/8/20.
//

import SwiftUI

struct AboutView: View {
    var pokemon: Pokemon
    var species: Species
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            AboutContentView(pokemon: pokemon, species: species)
            Color.clear.frame(height: 150, alignment: .center)
        }.background(Color.clear)
    }
}

struct AboutContentView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var id = UUID()
    var pokemon: Pokemon
    var species: Species
    
    @State var seletedString: String?
    @State var showAbilityDetail: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            GeneralDetailView(pokemon: pokemon,
                              species: species,
                              selectedString: $seletedString)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                .onChange(of: seletedString, perform: { seletedString in
                    withAnimation(.linear) {
                        if seletedString == nil {
                            showAbilityDetail = false
                        } else {
                            showAbilityDetail = true
                        }
                    }
                })
            
            if showAbilityDetail {
                AbilityDetailView(pokemon: pokemon, selectedAbility: $seletedString)
                    .padding()
            }
            
            SizeView(height: pokemon.height, weight: pokemon.weight)
                .background(isDarkMode ? Color.black : Color.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 3)
                .padding()
                .padding(.bottom, 20)
            
            if let genderRate = species.genderRate {
                Text("Breeding")
                .font(Biotif.extraBold(size: 20).font)
                .foregroundColor(.black)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
                BreedingView(rate: genderRate,
                             group: species.eggGroup?.first?.name ?? "",
                             habitat: species.habitat?.name ?? "")
                    .padding(.leading, 20)
                    .padding(.top, 10)
            }
            
            Spacer()
        }.background(Color.clear)
    }
}
