//
//  AbilityView.swift
//  Pokedex
//
//  Created by TriBQ on 19/10/2020.
//

import SwiftUI

struct AbilitesView: View {
    var pokemon: Pokemon
    @Binding var selectedString: String?

    var body: some View {
        VStack(spacing: 10) {
            Text("Abilities")
                .font(Biotif.extraBold(size: 20).font)
                .foregroundColor(.black)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            HStack(alignment: .center, spacing: 30) {
                ForEach(pokemon.abilities.map({$0.ability.name.capitalized}), content: { text in
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
                        }
                })
                Spacer()
            }
            .padding(.leading, 40)
            .transition(.opacity)
            .animation(.easeIn)
        }
    }
}

struct AbilityDetailView: View {
    var pokemon: Pokemon
    @Binding var selectedAbility: String?
    @StateObject var updater = AbilityUpdater(name: "")
    @State var isLoadingData = false
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
                        .foregroundColor(.black)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
            }
            .animation(.linear)
            .transition(.opacity)
            .padding(.leading, 20)
            
            if isLoadingData {
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
            isLoadingData = true
        }
        .onChange(of: selectedAbility, perform: { selectedAbility in
            if let selectedAbility = selectedAbility,
               selectedAbility != updater.name {
                updater.name = selectedAbility
                isLoadingData = true
            }
        })
        .onReceive(updater.$description, perform: { _ in
            isLoadingData = false
        })
        .background(Color.white)
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
