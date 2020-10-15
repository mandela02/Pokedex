//
//  MovesView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import SwiftUI

struct MovesView: View {
    var pokemon: Pokemon
    @StateObject var moveUpdater: MovesUpdater = MovesUpdater()
    
    var body: some View {
        TappableMoveCell()
            .onAppear {
                moveUpdater.pokemonMoves = pokemon.moves
            }
    }
}

struct TappableMoveCell: View {
    var type: PokemonType = .bug
    @State var isExtensed = true
    var body: some View {
        Button(action: {
            isExtensed.toggle()
        }, label: {
            MoveCell(type: type, isExtensed: $isExtensed)
        })
    }
}

struct MoveCell: View {
    var type: PokemonType = .bug
    @Binding var isExtensed: Bool

    var body: some View {
        GeometryReader(content: { geometry in
            let width = geometry.size.width
            let height = width * 0.4
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        Image("ic_pokeball")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(x: 150/3)
                            .scaleEffect(1.1)
                            .foregroundColor(type.color.background)
                    }
                    VStack() {
                        SkillNameView()
                            .padding(.top, 30)
                        Spacer()
                        SkillPowerView(type: type)
                            .padding(.bottom, 30)
                    }
                }
                .frame(width: width, height: height)
                if isExtensed {
                    VStack(spacing: 5) {
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Target")
                                    .font(Biotif.medium(size: 15).font)
                                    .foregroundColor(Color(.darkGray))
                                Text("Machine")
                                    .font(Biotif.medium(size: 15).font)
                                    .foregroundColor(Color(.darkGray))
                            }
                            VStack(alignment: .leading, spacing: 10) {
                                Text("All opposing Pokémon")
                                    .font(Biotif.medium(size: 15).font)
                                    .foregroundColor(Color.black)
                                Text("tm02")
                                    .font(Biotif.medium(size: 15).font)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }
                        .padding(.leading, 10)

                        TextInformationView()
                            .padding(.all, 5)
                    }
                }
            }
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(type.color.background, lineWidth: 5)
            )
            .cornerRadius(25)
            .animation(Animation.easeIn(duration: 0.5))
            .frame(width: width)
        })
    }
}

struct SkillNameView: View {
    var body: some View {
        HStack(alignment: .firstTextBaseline){
            Text("Razor-wind")
                .font(Biotif.bold(size: 40).font)
                .foregroundColor(.black)
            Spacer()
            Text("Lvl. 0")
                .font(Biotif.bold(size: 25).font)
                .foregroundColor(Color(.darkGray))
        }
        .padding(.leading, 20)
        .padding(.trailing, 30)
    }
}

struct SkillPowerView: View {
    var type: PokemonType = .bug
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            TypeBubbleCellView(text: type.rawValue.capitalizingFirstLetter(),
                               foregroundColor: type.color.text,
                               backgroundColor: type.color.background,
                               font: Biotif.book(size: 25).font)
            Spacer()
            HStack(alignment: .center, spacing: 20) {
                Text("Power: 20")
                    .font(Biotif.semiBold(size: 20).font)
                    .foregroundColor(Color(.darkGray))
                Text("PP: 20")
                    .font(Biotif.semiBold(size: 20).font)
                    .foregroundColor(Color(.darkGray))
            }
        }
        .padding(.leading, 50)
        .padding(.trailing, 30)
    }
}

struct TextInformationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("How to learn: " + "Eggs")
                .font(Biotif.bold(size: 15).font)
                .foregroundColor(Color(.black))
            
            Text("\t" + "Appears on a newly-hatched Pokémon, if the father had the same move.")
                .font(Biotif.book(size: 12).font)
                .foregroundColor(Color(.darkGray))
            
            Text("\t" + "Inflicts regular damage.  User's critical hit rate is one level higher when using this move.  User charges for one turn before attacking.\n\nThis move cannot be selected by sleep talk.")
                .font(Biotif.book(size: 12).font)
                .foregroundColor(Color(.darkGray))
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 8, x: -10, y: 10)
                .padding(.all, 10)
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
    }
}
