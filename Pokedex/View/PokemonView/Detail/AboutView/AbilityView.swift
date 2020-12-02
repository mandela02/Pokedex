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
    @State var showAbilityDetail: Bool = false
    @StateObject var updater = AbilityUpdater()

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
                        TypeBubbleCellView(text: text.eliminateDash,
                                           foregroundColor: text == updater.selectedString ? .white : .gray,
                                           backgroundColor: text == updater.selectedString ? .gray : (isDarkMode ? .black : .white),
                                           font: Biotif.semiBold(size: 15).font)
                            .onTapGesture {
                                updater.onTap(of: text)
                            }.disabled(reachabilityUpdater.hasNoInternet)
                            .disabled(updater.isLoading)
                    })
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 30, alignment: .center)
                .padding(.leading, 30)
                .transition(.opacity)
                .animation(.easeIn)
                
                if showAbilityDetail {
                    AbilityDetailView(pokemon: pokemon, model: $updater.selectedAbility)
                }
            }
        }
        .onChange(of: updater.selectedString, perform: { selectedString in
            withAnimation(.linear) {
                if selectedString == nil {
                    showAbilityDetail = false
                } else {
                    showAbilityDetail = true
                }
            }
        }).onAppear {
            updater.pokemon = pokemon
        }
    }
}

struct AbilityDetailView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false

    var pokemon: Pokemon
    @Binding var model: SelectedAbilityModel?
    
    @State var minHeight: CGFloat = 0.0

    var body: some View {
        ZStack {
            GeometryReader { reader in
                HStack() {
                    Spacer()
                    Image("ic_pokeball")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(x: 20, y: -20)
                        .foregroundColor(pokemon.mainType.color.background.opacity(0.5))
                        .onAppear {
                            withAnimation {
                                minHeight = reader.size.width * 0.3
                            }
                        }
                }.frame(height: minHeight)
            }

            HStack(spacing: 5) {
                Color.clear.frame(width: 10)
                AbilityDescriptionView(name: model?.name.eliminateDash ?? "",
                                       desccription: model?.description ?? "")
                Color.clear.frame(width: 10)
            }
        }
        .animation(.linear)
        .transition(.slide)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(pokemon.mainType.color.background.opacity(0.5),
                        lineWidth: 5)
        ).cornerRadius(25)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: minHeight)
    }
}

struct AbilityDescriptionView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    var name: String
    var desccription: String
    
    var body: some View {
        VStack(spacing: 5) {
            Color.clear.frame(height: 10)
            Text(name)
                .font(.system(size: 15))
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment: .leading)
            Text(desccription)
                .font(.system(size: 10))
                .fontWeight(.regular)
                .foregroundColor(isDarkMode ? .white : .black)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment: .leading)
            Color.clear.frame(height: 10)
        }
    }
}
