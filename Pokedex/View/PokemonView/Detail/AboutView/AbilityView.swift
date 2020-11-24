//
//  AbilityView.swift
//  Pokedex
//
//  Created by TriBQ on 19/10/2020.
//

import SwiftUI

struct AbilitesView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    
    var pokemon: Pokemon
    @Binding var selectedString: String?

    var body: some View {
        VStack(spacing: 10) {
            if let abilities = pokemon.abilities, !abilities.isEmpty  {
                Text("Abilities")
                    .font(Biotif.extraBold(size: 20).font)
                    .foregroundColor(isDarkMode ? .white : .black)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                HStack(alignment: .center, spacing: 30) {
                    ForEach(abilities.map({$0.ability.name.capitalizingFirstLetter()}), content: { text in
                        TypeBubbleCellView(text: text,
                                           foregroundColor: text == selectedString ? .white : .gray,
                                           backgroundColor: text == selectedString ? .gray : .white,
                                           font: Biotif.semiBold(size: 15).font)
                            .onTapGesture {
                                if text == selectedString {
                                    selectedString = nil
                                } else {
                                    selectedString = text
                                }
                            }.disabled(reachabilityUpdater.hasNoInternet)
                    })
                    Spacer()
                }
                .padding(.leading, 40)
                .transition(.opacity)
                .animation(.easeIn)
            }
        }
    }
}

struct AbilityDetailView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var pokemon: Pokemon
    @Binding var selectedAbility: String?
    @StateObject var updater = AbilityUpdater(name: "")

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Image("ic_pokeball")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(pokemon.mainType.color.background.opacity(0.5))
                        .scaleEffect(1.1)
                        .frame(width: 120, height: 120, alignment: .trailing)
                        .offset(x: 30, y: -20)
                }
                Spacer()
            }
            
            VStack(spacing: 5) {
                Text(updater.title)
                        .font(Biotif.bold(size: 15).font)
                        .foregroundColor(.gray)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               alignment: .leading)
                        .padding(.trailing, 20)

                    Text(updater.description)
                        .font(Biotif.regular(size: 12).font)
                        .foregroundColor(isDarkMode ? .white : .black)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
            }
            .animation(.linear)
            .transition(.opacity)
            .padding(.leading, 20)
            .isHidden(updater.isLoadingData)
            
            if updater.isLoadingData {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: pokemon.mainType.color.background))
                        .scaleEffect(1.2)
                    Spacer()
                }
            }
        }
        .onAppear {
            updater.name = selectedAbility ?? ""
        }
        .onChange(of: selectedAbility, perform: { selectedAbility in
            if let selectedAbility = selectedAbility,
               selectedAbility != updater.name {
                updater.name = selectedAbility
            }
        })
        .background(isDarkMode ? Color.black : Color.white)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(pokemon.mainType.color.background.opacity(0.5),
                        lineWidth: 5)
        )
        .cornerRadius(25)
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}
